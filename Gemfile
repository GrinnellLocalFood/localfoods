source 'http://rubygems.org'

gem 'rails', '3.2.11'
gem 'paperclip', '2.7.0'
gem 'cocaine', '0.3.2'

group :development, :test do
  gem 'sqlite3','1.3.5'
  gem 'rspec-rails', '2.11.0'
  gem 'factory_girl_rails', '1.4.0'
  gem 'prototype-rails'
  gem 'jquery-rails', '2.0.2'
  
  #leaving out annotate gem, it could not be found in sources
  #gem 'annotate-models'
end

group :production, :staging do
  gem 'pg'
end

group :test do
  gem 'rspec', '2.11.0'
  gem 'webrat', '0.7.1'
  gem 'shoulda'
  gem 'shoulda-matchers'
end

