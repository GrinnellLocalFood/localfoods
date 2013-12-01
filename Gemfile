source 'http://rubygems.org'

gem 'rails', '3.2.11'
gem 'paperclip', '2.7.0'
gem 'cocaine', '0.3.2'
gem 'sunspot_rails'
gem 'sunspot_solr' 
gem 'progress_bar'
gem 'sunspot_with_kaminari'
gem 'kaminari'
gem 'foreman'
gem 'tilt'
gem 'prawn'
gem 'prawnto'
gem 'thin'

gem 'jquery-rails'

# It seems production needs at least the LESS gem
gem 'less'
gem 'less-rails'

group :development, :test do
  gem 'sqlite3','1.3.5'
  gem 'rspec-rails', '2.11.0'
  gem 'factory_girl_rails', '1.4.0'
  gem 'capybara'
  gem 'ffaker'
  gem 'bullet'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :assets do
   gem 'uglifier'
   gem 'execjs'
   gem 'therubyracer'
   gem 'yui-compressor'
end

group :production, :staging do
  gem 'sqlite3','1.3.5'
  gem 'passenger'
end

group :test do
  gem 'shoulda'
  gem 'shoulda-matchers'
  gem 'sunspot_test'
end

