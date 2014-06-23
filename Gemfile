source 'https://rubygems.org'

gem 'rails', '4.1.1'

### App Server ###
gem 'unicorn'

### Datastore ###
gem 'mongoid',  '4.0.0.rc2'
gem 'devise',   '~> 3.2.2'

gem 'mongoid-sleeping_king_studios', '~> 0.7', '>= 0.7.9'

### Assets ###
gem 'haml-rails',        '~> 0.4'
gem 'sass-rails',        '~> 4.0', '>= 4.0.3'
gem 'coffee-rails',      '~> 4.0'
gem 'jquery-rails',      '~> 3.1'
gem 'uglifier',          '>= 1.3.0' # Compressor for JavaScript assets
gem 'compass-rails',     '~> 1.1.2'
gem 'foundation-rails',  '~> 5.0.3'

### Content ###
gem 'redcarpet', '~> 3.0.0'

### Support ###
# gem 'debugger', group: [:development, :test]
gem 'jbuilder', '~> 1.2' # Build JSON APIs. Read more: https://github.com/rails/jbuilder
# gem 'turbolinks' # Read more: https://github.com/rails/turbolinks

### App Preloader ###
gem 'spring', :group => :development

### Documentation ###
group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end # group

### Inline Console ###
group :development, :test do
  gem 'pry',           '~> 0.9.12'
  gem 'jasmine-rails', '~> 0.6'
end # group

### Testing ###
group :test do
  gem 'rspec-rails',                 '~> 3.0'
  gem 'rspec-sleeping_king_studios', '2.0.0.alpha'
  gem 'factory_girl_rails',          '~> 4.2.0'
  gem 'database_cleaner',            '~> 1.2.0'
end # group

### Production ###
group :production do
  # Required for Heroku deployment.
  gem 'rails_12factor', '~> 0.0.2'
end # group

ruby "2.1.2"
