# spec/controllers/admin/blog_posts_controller_spec.rb

require 'spec_helper'

RSpec.describe Admin::BlogPostsController do
  include Appleseed::SharedExamples::AdminControllerAuthenticatesUser

  context 'with a blog post' do
    let(:blog_post)   { FactoryGirl.create :blog_post }
    let(:resource_id) { blog_post.id }

    expect_behavior 'authenticates the user for resources', described_class, :except => :index
  end # context

  context 'with no authenticated user' do
    describe 'GET /admin/blog/posts' do
      it 'redirects to root' do
        get :index
        expect(response.status).to be == 302
        expect(response).to redirect_to :root
      end # it
    end # describe
  end # context

  context 'with an authenticated user' do
    let(:user) { FactoryGirl.create :user }

    before(:each) { sign_in user }

    describe 'GET /admin/blog/posts' do
      it 'redirects to admin blog' do
        get :index
        expect(response.status).to be == 302
        expect(response).to redirect_to admin_blog_path
      end # it
    end # describe

    describe 'POST /admin/blog/posts' do
      let(:blog) { FactoryGirl.create :blog }
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
        let(:blog_post) { BlogPost.last }

        it 'redirects to the admin show post path' do
          perform_action
          expect(response.status).to be == 302
          expect(response).to redirect_to admin_blog_post_path(blog_post)
        end # it

        it 'creates a new post' do
          expect {
            perform_action
          }.to change(BlogPost, :count).to(1)
        end # it

        it 'sets the post\'s author to the current user' do
          perform_action
          expect(blog_post.author).to be == user
        end # it
      end # context
    end # describe

    context 'with a blog post' do
      let!(:blog_post) { FactoryGirl.create :blog_post }
      
      describe 'PATCH /admin/blog/posts/:id' do
        let(:attributes) { {} }

        def perform_action
          patch :update, :id => blog_post.id, :blog_post => attributes
        end # method perform_action

        context 'with invalid parameters' do
          let(:attributes) { { :content_type => nil } }

          it 'responds with 200 ok and renders the edit template' do
            perform_action
            expect(response.status).to be == 200
            expect(response).to render_template 'edit'
          end # it

          it 'does not update the post' do
            expect {
              perform_action
              blog_post.reload
            }.not_to change(blog_post, :content_type)
          end # it
        end # context

        context 'with valid parameters' do
          let(:title)      { 'Custom Blog Post Title' }
          let(:attributes) { { :title => title } }

          it 'redirects to the admin show post path' do
            perform_action
            expect(response.status).to be == 302
            expect(response).to redirect_to admin_blog_post_path(blog_post)
          end # it

          it 'updates the post' do
            expect {
              perform_action
              blog_post.reload
            }.to change(blog_post, :title).to(title)
          end # it
        end # context
      end # describe

      describe 'DELETE /admin/blog/posts/:id' do
        def perform_action
          delete :destroy, :id => blog_post.id
        end # method perform_action

        it 'redirects to the admin blog path' do
          perform_action
          expect(response.status).to be == 302
          expect(response).to redirect_to admin_blog_path
        end # it

        it 'destroys the blog post' do
          expect {
            perform_action
          }.to change(BlogPost, :count).to(0)
        end # it
      end # describe
    end # context
  end # context
end # describe
