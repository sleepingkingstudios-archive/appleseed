# spec/spec_helper.rb

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  # Automatically mix in different behaviours to your tests based on their
  # file location.
  config.infer_spec_type_from_file_location!

  # Limit a spec run to individual examples or groups by tagging them with
  # `:focus` metadata.
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
  Kernel.srand config.seed

  # Alias "it should behave like" to 2.13-like syntax.
  config.alias_it_should_behave_like_to 'expect_behavior', 'has behavior'

  # Allow more verbose output when running an individual spec file.
  if config.files_to_run.one?
    # Use the documentation formatter for detailed output,
    # unless a formatter has already been configured.
    config.default_formatter = 'doc'
  end # if

  # rspec-expectations config goes here.
  config.expect_with :rspec do |expectations|
    # Enable only the newer, non-monkey-patching expect syntax.
    expectations.syntax = :expect
  end # expect_with

  # rspec-mocks config goes here.
  config.mock_with :rspec do |mocks|
    # Enable only the newer, non-monkey-patching expect syntax.
    mocks.syntax = :expect

    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended.
    mocks.verify_partial_doubles = true
  end # mock_with

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end # before suite

  config.after(:each) do
    DatabaseCleaner.clean
  end # after each
end # configure
