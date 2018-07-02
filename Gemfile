source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'
gem 'rails', '~> 5.2.0'
gem 'pg'
gem 'simplecov', require: false, group: :test
gem 'devise'
gem 'devise_cas_authenticatable'
gem 'puma', '~> 3.11'
gem 'bootstrap'
gem 'newrelic_rpm'
gem 'jquery-rails'
gem 'jquery-easing-rails'
gem 'sass-rails', '~> 5.0'
gem 'turbolinks', '~> 5'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'httparty'
gem 'vcr'
gem 'webmock'
gem 'figaro'
gem 'materialize-sass', '~> 1.0.0.rc1'
gem 'slack-notifier'
group :development, :test do
  gem 'rspec-rails', '~> 3.7'
  gem 'pry'
  gem 'rails-controller-testing'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :production do
	gem 'uglifier'
	gem 'rails_12factor'
end