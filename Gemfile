source 'https://rubygems.org'

gem 'rails', '4.0.2'

### App Server ###
# gem 'unicorn'

### Datastore ###
gem 'mongoid',  '4.0.0.alpha2', github: 'mongoid/mongoid'
gem 'devise',   '~> 3.2.2'

gem 'mongoid-sleeping_king_studios', '~> 0.7.6'

### Assets ###
gem 'haml-rails',        '~> 0.4'
gem 'sass-rails',        '~> 4.0.0'
gem 'coffee-rails',      '~> 4.0.0'
gem 'jquery-rails',      '~> 3.0.4'
gem 'uglifier',          '>= 1.3.0' # Compressor for JavaScript assets
gem 'compass-rails',     '~> 1.1.2'
gem 'foundation-rails',  '~> 5.0.2'

### Support ###
# gem 'debugger', group: [:development, :test]
# gem 'jbuilder', '~> 1.2' # Build JSON APIs. Read more: https://github.com/rails/jbuilder
# gem 'turbolinks' # Read more: https://github.com/rails/turbolinks

### Documentation ###
group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end # group

group :development, :test do
  gem 'pry', '~> 0.9.12'
end # group

### Testing ###
group :test do
  gem 'rspec-rails',                 '~> 2.14.0'
  gem 'rspec-sleeping_king_studios', '>= 1.0.1'
  gem 'fuubar',                      '~> 1.2.1'
  gem 'factory_girl_rails',          '~> 4.2.0'
  gem 'database_cleaner',            '~> 1.2.0'
end # group
