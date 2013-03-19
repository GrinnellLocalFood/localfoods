source 'http://rubygems.org'

gem 'rails', '3.2.11'
gem 'jquery-rails'
gem 'paperclip', '2.7.0'
gem 'cocaine', '0.3.2'
gem 'sunspot_rails'
gem 'sunspot_solr' 
gem 'progress_bar'
gem 'sunspot_with_kaminari'
gem 'kaminari'
gem 'foreman'

group :development, :test do
  gem 'sqlite3','1.3.5'
  gem 'rspec-rails', '2.11.0'
  gem 'factory_girl_rails', '1.4.0'
  gem 'capybara'
  gem 'ffaker'
  
  #leaving out annotate gem, it could not be found in sources
  #gem 'annotate-models'
end

group :production, :staging do
  gem 'pg'
end

group :test do
  gem 'shoulda'
  gem 'shoulda-matchers'
  gem 'sunspot_test'
end

