if ENV['RUBYTAOBAO']
  source 'https://ruby.taobao.org'
else
  source 'https://rubygems.org'
end

gem 'rails', '4.2.5'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'pg', '~> 0.18.0'

gem 'jquery-rails'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'bootstrap-sass', '~> 3.3.5'
gem 'slim-rails', '~> 3.0.1'

# markdown
gem 'redcarpet', '~> 3.3.3'
gem 'rouge', github: "stanhu/rouge"

# configuration
gem 'figaro', '~> 1.1.1'

# file upload
gem 'carrierwave', '~> 0.10.0'
gem "jquery-fileupload-rails", '~> 0.4.5'
gem 'carrierwave-aliyun', '~> 0.3.5'
gem 'mini_magick', '~> 4.3.3'

# for deploy
group :development do
  gem 'mina', require: false
  gem 'unicorn', '~> 4.9.0'
  gem 'mina-unicorn', :require => false
  gem 'mina-sidekiq', require: false
end

gem 'kaminari', '~> 0.16.3'
gem 'kaminari-i18n', '~> 0.3.2'
gem 'awesome_print', '~> 1.6.1'

# monitor
gem 'oneapm_rpm', '~> 1.2.2'
gem 'rack-mini-profiler', require: false

# background
gem 'sidekiq', '~> 4.0.2'

# notification
gem 'exception_notification', github: 'smartinez87/exception_notification'

# tag
gem 'acts-as-taggable-on', '~> 3.4'

# seo
gem 'meta-tags', '~> 2.0.0'

# friendly url
gem 'friendly_id', '~> 5.1.0'
gem 'ruby-pinyin', '~> 0.4.6'
gem 'babosa', '~> 1.0.2'

# full text search
gem 'pg_search', '~> 1.0.5'
gem 'rails-i18n', '~> 4.0.4'

# redis cache
gem 'redis-namespace', '~> 1.5.2'
gem 'redis-rails', '~> 4.0.0'
gem "hiredis", '~> 0.6.0'

group :development, :test do
  gem 'byebug'
  gem 'web-console', '~> 2.0'
  gem 'spring'
  gem 'rspec-rails', '~> 3.3.3'
  gem 'database_cleaner', '~> 1.4.1'
  gem 'factory_girl_rails', '~> 4.5.0'
end

group :development do
  gem 'capistrano', '~> 3.4.0'
  gem 'capistrano-rbenv', '~> 2.0.3'
  gem 'capistrano-bundler', '~> 1.1.4'
  gem 'capistrano-rails', '~> 1.1.3'
  gem 'capistrano3-unicorn', '~> 0.2.1'
  gem 'capistrano-sidekiq', '~> 0.5.4'
  gem 'capistrano-faster-assets', '~> 1.0.2'
  
  gem 'quiet_assets'
  gem 'pry'
end

gem 'sinatra', '~> 1.4.6', :require => nil
gem 'pghero', '~> 1.2.1'

# 搜索
gem 'elasticsearch', git: 'git://github.com/elasticsearch/elasticsearch-ruby.git'
gem 'elasticsearch-model', git: 'git://github.com/elasticsearch/elasticsearch-rails.git'
gem 'elasticsearch-rails', git: 'git://github.com/elasticsearch/elasticsearch-rails.git'
