source 'https://rubygems.org'

# Let's load environment variables from the the .env file.
gem 'dotenv-rails'

group :test do
  # Pretty printed test output
  gem 'turn', '0.8.2', require: false
  gem 'shoulda-matchers'
end

group :development do
  gem 'guard'
  gem 'guard-rspec'
  gem 'metric_fu'
  gem 'rails_best_practices'
  gem 'thin'
  gem 'quiet_assets'
end

group :development, :test do
  gem 'rspec'
  gem 'rake'
  gem 'yard'
  gem 'ci_reporter'
  gem 'simplecov-rcov'
  gem 'rdiscount'
  gem 'rspec-rails', '~> 2.14.0'
  gem 'simplecov'
  gem 'fakeweb'
end

gem 'rails', '4.0.1'

# Let's use MySQL as the default option for database. We can use other flavors as well. However if you change this, make
# sure you edit config/database.yml and update the value of the adapter key.
gem 'mysql2' # Or 'sqlite3', 'pg', etc.

gem 'sass-rails', '~> 4.0.1' # Use SCSS for stylesheets
gem 'uglifier', '>= 1.3.0' # Use Uglifier as compressor for JavaScript assets
gem 'coffee-rails', '~> 4.0.1' # Use CoffeeScript for .js.coffee assets and views
gem 'jquery-rails' # Use jquery as the JavaScript library
gem 'turbolinks' # Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

gem 'therubyracer' # JS Runtime.
gem 'foreman' # Used by push_daemon.
gem 'higcm', '~> 0.0.5' # Google cloud message wrapper.
gem 'omniauth-google-oauth2' # Google login.
gem 'authlogic' # Browser session management.
