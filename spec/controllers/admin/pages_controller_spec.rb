# spec/controllers/admin/pages_controller_spec.rb

require 'spec_helper'

RSpec.describe Admin::PagesController do
  include Appleseed::SharedExamples::AdminControllerAuthenticatesUser

  expect_behavior 'authenticates the user for action', described_class, :index
end # describe
