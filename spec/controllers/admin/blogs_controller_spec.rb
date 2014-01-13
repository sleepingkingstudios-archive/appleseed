# spec/controllers/admin/blogs_controller_spec.rb

require 'spec_helper'

RSpec.describe Admin::BlogsController do
  include Appleseed::SharedExamples::AdminControllerAuthenticatesUser

  expect_behavior 'authenticates the user', described_class, :only => %i(show)
end # describe
