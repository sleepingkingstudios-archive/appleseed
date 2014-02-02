# spec/routing/admin/blog_posts_spec.rb

require 'spec_helper'

RSpec.describe 'routes for Admin::BlogPost' do
  include Appleseed::SharedExamples::RoutesToResource

  expect_behavior 'routes to resources', 'admin/blog_posts' do
    let(:controller_path) { 'admin/blog/posts' }
  end # shared behavior
end # describe
