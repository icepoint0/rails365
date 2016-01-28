class ArticlesController < ApplicationController
  before_action :set_article, only: [:show]

  def index
    if params[:search].present?
      @articles = Article.except_body_with_default.search_by_title_or_body(params[:search]).order("id DESC").page(params[:page])
    elsif params[:tag_id] && @tag = ActsAsTaggableOn::Tag.find_by(id: params[:tag_id])
      @articles = Article.except_body_with_default.tagged_with(@tag.name).order("id DESC").page(params[:page])
    else
      @articles = Article.except_body_with_default.order("id DESC").page(params[:page])
    end
    set_meta_tags title: '文章列表'
  end

  def show
    set_meta_tags title: @article.title, description: @article.meta_description || @article.title, keywords: @article.meta_keyword
    @group_name = Rails.cache.fetch "article:#{@article.id}/group_name" do
      @article.group.try(:name) || ""
    end
    @recommend_articles = Rails.cache.fetch "article:#{@article.id}/recommend_articles" do
      Article.except_body_with_default.search_by_title_or_body(@group_name).order("visit_count DESC").limit(11).to_a
    end
    @tags = Rails.cache.fetch "article:#{@article.id}/tags" do
      @article.tag_counts_on(:tags)
    end
  end

  def search
    @articles = Article.search(params[:q]).records
    render action: "index"
  end

  private
    def set_article
      @article = Rails.cache.fetch "article:#{params[:id]}" do
        Article.find(params[:id])
      end
      if request.path != article_path(@article)
        return redirect_to @article, :status => :moved_permanently
      end
    end

end
