# spec/routing/blogs_spec.rb

require 'spec_helper'

RSpec.describe 'routes for Blogs' do
  include Appleseed::SharedExamples::RoutesToResource

  expect_behavior 'routes to singular resource', 'blogs', :only => %i(show)

  expect_behavior 'does not route to singular resource', 'blogs', :except => %i(show)
end # describe
