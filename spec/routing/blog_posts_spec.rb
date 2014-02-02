# spec/routing/blog_posts_spec.rb

require 'spec_helper'

RSpec.describe 'routes for BlogPost' do
  include Appleseed::SharedExamples::RoutesToResource

  expect_behavior 'routes to resources', 'blog_posts', :only => %i(show) do
    let(:controller_path) { 'blog/posts' }
  end # shared behavior

  expect_behavior 'does not route to resources', 'blog_posts', :except => %i(show) do
    let(:controller_path) { 'blog/posts' }
  end # shared behavior
end # describe
