# spec/routing/blog_tags_spec.rb

require 'spec_helper'

RSpec.describe 'routes for Blog ~> Tags' do
  include Appleseed::SharedExamples::RoutesToResource

  expect_behavior 'routes to resources', 'blog_tags', :only => %i(show) do
    let(:controller_path) { 'blog/tags' }
  end # shared behavior

  expect_behavior 'does not route to resources', 'blog_tags', :except => %i(show) do
    let(:controller_path) { 'blog/tags' }
  end # shared behavior
end # describe
