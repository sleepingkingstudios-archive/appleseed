# spec/controllers/blog_posts_controller_spec.rb

require 'spec_helper'

RSpec.describe BlogPostsController do
  let(:blog)      { FactoryGirl.create :blog }
  let(:blog_post) { FactoryGirl.create :blog_post, :blog => blog }

  describe 'show' do
    def perform_request
      get :show, :id => blog_post.id
    end # method perform_request

    it 'responds with 200 ok and renders the show template' do
      perform_request
      expect(response.status).to be == 200
      expect(response).to render_template 'show'
    end # it
  end # describe
end # describe
