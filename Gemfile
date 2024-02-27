source 'http://mirrors.aliyun.com/rubygems/'
# source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.3"

gem "rails", "~> 7.0.7"
gem "sprockets-rails"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"

# Cache
gem "redis", "~> 4.0"

# Auth
gem 'jwt', '~> 2.7', '>= 2.7.1'

# ipdb
gem 'ipip-ipdb', '~> 0.0.6'

# page
gem 'kaminari', '~> 1.2'

# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1.7'

# rspec+docs
gem 'rswag', '~> 2.11'
gem 'faker'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'rspec-rails', '~> 6.0.0'
  gem 'factory_bot_rails', '~> 6.2'
  gem 'pry'
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end
