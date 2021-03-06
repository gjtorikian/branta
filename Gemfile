source 'https://rubygems.org'

# important stuff
gem 'foreman', '~> 0.71'
gem 'rake'
gem 'rails', '4.1.4'
gem 'pg', '~> 0.17.1'
gem 'turbolinks'
gem 'unicorn'
gem "octokit"
gem "warden-github-rails", "1.1.0"
gem 'high_voltage', '~> 2.2.1'

# search stuff
gem "resque", '~> 1.25'
gem "resque-lock-timeout", '~> 0.4'
gem 'elasticsearch-model', '~> 0.1'
gem 'elasticsearch-persistence', '~> 0.1'
gem 'nokogiri', '~> 1.5'
gem 'pismo', '~> 0.7.4'
gem 'sitemap-parser', '~> 0.2'
gem 'anemone', '~> 0.7'
gem 'typhoeus', '~> 0.6'
gem 'robotstxt-parser', '~> 0.1'

# assets stuff
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'bootstrap-sass', '~> 3.2'
gem 'bootstrap-sass-extras'

group :test do
  gem 'minitest-rails'
  gem 'minitest-focus'
  gem 'shoulda-matchers'
  gem 'database_cleaner'
  gem 'minifacture'
  gem 'capybara'
  gem 'capybara_minitest_spec'
  gem 'mocha', '~> 1.1.0'
  gem 'webmock', '~> 1.18'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'dotenv-rails'
  gem 'mina'
  gem 'mina-unicorn', :require => false
end

group :test, :development do
  gem 'awesome_print'
  gem 'bundler'
  gem 'pry-byebug'
end
