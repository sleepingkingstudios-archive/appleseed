# spec/controllers/admin/settings_controller_spec.rb

require 'spec_helper'

RSpec.describe Admin::SettingsController do
  include Appleseed::SharedExamples::AdminControllerAuthenticatesUser

  expect_behavior 'authenticates the user for singular resource', described_class, :only => %i(show update)
end # describe
