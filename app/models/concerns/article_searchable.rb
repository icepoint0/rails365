module ArticleSearchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    # 定义es的index的名字
    #
    index_name [Rails.application.engine_name, Rails.env].join('_')
    document_type "article"

    # Index configuration and mapping
    #
    settings index: { number_of_shards: 1, number_of_replicas: 0 } do
      mapping do
        indexes :title, type: 'multi_field' do 
          indexes :title,     analyzer: 'ik_max_word'
          indexes :tokenized, analyzer: 'simple'
        end
        
        indexes :body, type: 'multi_field' do 
          indexes :body,      analyzer: 'ik_max_word'
          indexes :tokenized, analyzer: 'simple'
        end

        indexes :updated_at, type: 'date'
        
        indexes :tags, type: 'nested' do
          indexes :name, analyzer: 'simple'
        end

        indexes :group do
          indexes :name, analyzer: 'simple'
        end
      end
    end

    # Set up callbacks for updating the index on model changes
    #
    after_commit lambda { Indexer.perform_async(:index,  self.class.to_s, self.id) }, on: :create
    after_commit lambda { Indexer.perform_async(:update, self.class.to_s, self.id) }, on: :update
    after_commit lambda { Indexer.perform_async(:delete, self.class.to_s, self.id) }, on: :destroy
    after_touch  lambda { Indexer.perform_async(:update, self.class.to_s, self.id) }

    # Customize the JSON serialization for Elasticsearch
    #

    def as_indexed_json(options={})
      hash = self.as_json(
        include: {
          group: { only: [:name] },
          tags:  { only: [:name] }
        })
      # hash['tags'] = self.tags.map(&:name)
      hash
    end

    def self.search(query, options={})

      __set_filters = lambda do |key, f|
        @search_definition[:post_filter][:and] ||= []
        @search_definition[:post_filter][:and]  |= [f]

        @search_definition[:aggregations][key.to_sym][:filter][:bool][:must] ||= []
        @search_definition[:aggregations][key.to_sym][:filter][:bool][:must]  |= [f]
      end

      @search_definition = {
        query: {},

        highlight: {
          pre_tags: ['<em class="label label-highlight">'],
          post_tags: ['</em>'],
          fields: {
            title:    { number_of_fragments: 0 },
            body:     { fragment_size: 50 }
          }
        },

        post_filter: {},

        # aggregations: {
        #   group: {
        #     filter: { bool: { must: [ macth_all: {} ] } },
        #     aggregations: { group: { terms: { field: 'group.name' } } }
        #   },
        #   tags: {
        #     filter: { bool: { must: [ macth_all: {} ] } },
        #     aggregations: { tags: { terms: { field: 'tags.name' } } }
        #   }
        # }
      }

      unless query.blank?
        @search_definition[:query] = {
          bool: {
            should: [
              { multi_match:  {
                  query: query,
                  fields: ['title^2', 'body', 'tags.name'],
                  operator: 'and'
                }
              }
            ]
          }
        }
      else
        @search_definition[:query] = { match_all: {} }
      end

      # TODO
      if options[:tag]
      end

      if options[:group]
      end

      if options[:sort]
      end

      __elasticsearch__.search(@search_definition)
    end
  end
end
