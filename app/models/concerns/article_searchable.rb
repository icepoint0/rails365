module ArticleSearchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    # 定义es的index的名字
    index_name [Rails.application.engine_name, Rails.env].join('_')
    document_type "article"

    # Index configuration and mapping
    settings index: { number_of_shards: 1 } do
      mapping do
        indexes :title, analyzer: 'ik_max_word'
        indexes :body, analyzer: 'ik_max_word'
        indexes :updated_at, type: 'date'

        indexes :tags do
          indexes :name, analyzer: 'ik_max_word'
        end

        indexes :group do
          indexes :name, analyzer: 'ik_max_word'
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
          group: { only: [:name] }
        }
      )
      hash['tags'] = self.tags.map(&:name)
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
        query: {
          multi_match: {
            query: query,
            fields: ["title^2", "body"],
          }
        },

        highlight: {
          pre_tags: ['<em class="label label-highlight">'],
          post_tags: ['</em>'],
          fileds: {
            title:    { number_of_fragments: 0 },
            body:     { number_of_fragments: 0 }
            # "tags.name" => { number_of_fragments: 0 },
            # "group.name" => { number_of_fragments: 0 }
          }
        },

        post_filter: {},

        aggregations: {
          group: {
            filter: { bool: { must: [ macth_all: {} ] } },
            aggregations: { group: { terms: { field: 'group.name' } } }
          },
          tags: {
            filter: { bool: { must: [ macth_all: {} ] } },
            aggregations: { tags: { terms: { field: 'tags.name' } } }
          }
        }
      }

      if query.blank?
        @search_definition[:query] = { match_all: {} }
      end

      # unless query.blank?
      #   @search_definition[:query] = {
      #     bool: {
      #       should: [
      #         {
      #           multi_match: {
      #             query: query,
      #             fileds: ['title^2', 'body'],
      #             oprator: 'and'
      #           }
      #         }
      #       ]
      #     }
      #   }
      # else
      #   @search_definition[:query] = { match_all: {} }
      # end

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
