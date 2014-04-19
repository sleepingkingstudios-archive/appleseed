# spec/controllers/blog_tags_controller_spec.rb

require 'spec_helper'

RSpec.describe BlogTagsController do
  let(:blog)      { FactoryGirl.create :blog }
  let(:blog_post) { FactoryGirl.create :blog_post, :blog => blog }
  let(:tagging)   { FactoryGirl.create :tagging, :taggable => blog_post }

  describe 'show' do
    def perform_action
      get :show, :id => tagging.slug
    end # method perform_action

    it 'responds with 200 ok and renders the show template' do
      perform_action
      expect(response.status).to be == 200
      expect(response).to render_template 'show'
    end # it
  end # describe
end # describe
