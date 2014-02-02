# spec/routing/admin/blogs_spec.rb

require 'spec_helper'

RSpec.describe 'routes for Admin::Blogs' do
  include Appleseed::SharedExamples::RoutesToResource

  expect_behavior 'routes to singular resource', 'admin/blogs'
end # describe
