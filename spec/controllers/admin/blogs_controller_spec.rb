# spec/controllers/admin/blogs_controller_spec.rb

require 'spec_helper'

RSpec.describe Admin::BlogsController do
  include Appleseed::SharedExamples::AdminControllerAuthenticatesUser

  expect_behavior 'authenticates the user', described_class, :only => %i(show new create)

  context 'with no authenticated user' do
    describe 'GET /admin/blog/edit' do
      context 'with no existing blog' do
        it 'redirects to root' do
          get :edit
          expect(response.status).to be == 302
          expect(response).to redirect_to :root
        end # it
      end # context

      context 'with an existing blog' do
        before(:each) { FactoryGirl.create :blog }

        expect_behavior 'authenticates the user', described_class, :only => :edit
      end # context
    end # describe

    describe 'PATCH /admin/blog' do
      context 'with no existing blog' do
        it 'redirects to root' do
          patch :update
          expect(response.status).to be == 302
          expect(response).to redirect_to :root
        end # it
      end # context

      context 'with an existing blog' do
        before(:each) { FactoryGirl.create :blog }

        expect_behavior 'authenticates the user', described_class, :only => :update
      end # context
    end # describe
  end # context

  context 'with an authenticated user' do
    let(:user) { FactoryGirl.create :user }

    before(:each) { sign_in user }

    describe 'GET /admin/blog/new' do
      context 'with an existing blog' do
        before(:each) { FactoryGirl.create :blog }

        it 'redirects to the admin blog path' do
          get :new
          expect(response.status).to be == 302
          expect(response).to redirect_to admin_blog_path
        end # it
      end # context      
    end # describe

    describe 'POST /admin/blog' do
      let(:attributes) { FactoryGirl.attributes_for :blog }

      def perform_action
        post :create, :blog => attributes
      end # method perform_action

      context 'with an existing blog' do
        before(:each) { FactoryGirl.create :blog }

        it 'redirects to the admin blog path' do
          perform_action
          expect(response.status).to be == 302
          expect(response).to redirect_to admin_blog_path
        end # it

        it 'does not create a new blog' do
          expect {
            perform_action
          }.not_to change(Blog, :count)
        end # it
      end # context

      context 'with an invalid blog' do
        let(:attributes) { {} }

        it 'responds with 200 ok and renders the new template' do
          perform_action
          expect(response.status).to be == 200
          expect(response).to render_template 'new'
        end # it

        it 'does not create a new blog' do
          expect {
            perform_action
          }.not_to change(Blog, :count)
        end # it
      end # context

      context 'with a valid blog' do
        it 'redirects to the admin blog path' do
          perform_action
          expect(response.status).to be == 302
          expect(response).to redirect_to admin_blog_path
        end # it

        it 'creates a new blog' do
          expect {
            perform_action
          }.to change(Blog, :count).to(1)
        end # it
      end # context
    end # describe

    describe 'GET /admin/blog/edit' do
      context 'with no existing blog' do
        it 'redirects to the admin blog path' do
          get :edit
          expect(response.status).to be == 302
          expect(response).to redirect_to admin_blog_path
        end # it
      end # context
    end # describe

    describe 'PATCH /admin/blog' do
      let(:title) { nil }
      let(:data)  { { :title => title } }

      def perform_action
        patch :update, :blog => data
      end # method perform_action

      context 'with no existing blog' do
        it 'redirects to the admin blog path' do
          perform_action
          expect(response.status).to be == 302
          expect(response).to redirect_to admin_blog_path
        end # it
      end # context

      context 'with invalid parameters' do
        let!(:blog) { FactoryGirl.create :blog }

        it 'responds with 200 ok and renders the edit template' do
          perform_action
          expect(response.status).to be == 200
          expect(response).to render_template 'edit'
        end # it

        it 'does not update the blog' do
          expect {
            perform_action
            blog.reload
          }.not_to change {
            blog.title
          } # end change
        end # it
      end # context

      context 'with valid parameters' do
        let!(:blog) { FactoryGirl.create :blog }
        let(:title) { 'Custom Blog Title' }

        it 'redirects to the admin blog path' do
          perform_action
          expect(response.status).to be == 302
          expect(response).to redirect_to admin_blog_path
        end # it

        it 'does not update the blog' do
          expect {
            perform_action
            blog.reload
          }.to change {
            blog.title
          }.to(title)
        end # it
      end # context
    end # describe
  end # context
end # describe
