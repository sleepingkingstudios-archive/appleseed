# spec/controllers/admin/blog_posts_controller_spec.rb

require 'spec_helper'

RSpec.describe Admin::BlogPostsController do
  include Appleseed::SharedExamples::AdminControllerAuthenticatesUser

  expect_behavior 'authenticates the user', described_class, :only => %i(new create)

  context 'with an authenticated user' do
    let(:user) { FactoryGirl.create :user }

    before(:each) { sign_in user }

    describe 'POST' do
      let!(:blog) { FactoryGirl.create :blog }
      let(:attributes) do
        attrs = FactoryGirl.attributes_for(:blog_post)
        attrs.merge :author_id => user.id, :blog_id => blog.id
      end # let

      def perform_action
        post :create, :blog_post => attributes
      end # method perform_action

      context 'with an invalid post' do
        let(:attributes) { {} }

        it 'responds with 200 ok and renders the new template' do
          perform_action
          expect(response.status).to be == 200
          expect(response).to render_template 'new'
        end # it

        it 'does not create a new post' do
          expect {
            perform_action
          }.not_to change(BlogPost, :count)
        end # it
      end # context

      context 'with a valid post' do
        it 'redirects to the admin show post path' do
          perform_action
          expect(response.status).to be == 302
          expect(response).to redirect_to admin_blog_path
        end # it

        it 'creates a new post' do
          expect {
            perform_action
          }.to change(BlogPost, :count).to(1)
        end # it
      end # context
    end # describe
  end # context
end # describe
