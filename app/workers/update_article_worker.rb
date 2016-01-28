class UpdateArticleWorker

  include Sidekiq::Worker

  def perform(article_id, article_params)
    logger.info 'update article begin'
    @article = Article.find(article_id)
    Rails.cache.delete "group:#{@article.group_id}/articles"
    Rails.cache.delete "group:#{@article.group.try(:friendly_id)}"
    @article.update!(article_params)

    # 首页
    Rails.cache.delete "articles"
    Rails.cache.delete "hot_articles"
    Rails.cache.delete "groups"
    # 分类show页面的keyworkds meta
    Rails.cache.delete "group:#{@article.group_id}/tag_list"
    Rails.cache.delete "group:#{@article.group_id}"

    # 文章搜索用的group name
    Rails.cache.delete "article:#{@article.id}/group_name"
    # 文章show页面右侧推荐文章列表
    Rails.cache.delete "article:#{@article.id}/recommend_articles"
    # 文章show页面右侧标签
    Rails.cache.delete "article:#{@article.id}/tags"
    # 文章
    Rails.cache.delete "article:#{@article.slug}"
    logger.info 'update article end'
  end

end