# spec/controllers/admin/blog_posts_controller_spec.rb

require 'spec_helper'

RSpec.describe Admin::BlogPostsController do
  include Appleseed::SharedExamples::AdminControllerAuthenticatesUser

  context 'with a blog post' do
    let(:blog_post)   { FactoryGirl.create :blog_post }
    let(:resource_id) { blog_post.id }

    expect_behavior 'authenticates the user for resources', described_class, :except => :index

    expect_behavior 'authenticates the user for action',    described_class, :preview, :method => :post

    expect_behavior 'authenticates the user for action',    described_class, :import

    expect_behavior 'authenticates the user for action',    described_class, :import, :method => :post

    context do
      let(:params) { { :id => blog_post.id } }

      expect_behavior 'authenticates the user for action', described_class, :preview

      expect_behavior 'authenticates the user for action', described_class, :publish, :method => :patch
    end # context
  end # context

  context 'with no authenticated user' do
    describe 'index' do
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

    describe 'index' do
      it 'redirects to admin blog' do
        get :index
        expect(response.status).to be == 302
        expect(response).to redirect_to admin_blog_path
      end # it
    end # describe

    describe 'preview' do
      let(:attributes) { FactoryGirl.attributes_for :blog_post }

      it 'responds with 200 ok and renders the preview template' do
        post :preview, :blog_post => attributes
        expect(response.status).to be == 200
        expect(response).to render_template 'preview'
      end # it
    end # describe

    context 'with a blog' do
      let!(:blog) { FactoryGirl.create :blog }

      describe 'index.json' do
        render_views

        it 'returns an empty JSON array' do
          get :index, :format => :json
          expect(response.status).to be == 200
          expect(response.body).to be == '[]'
        end # it
      end # describe

      describe 'create' do
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

          it 'sets the post\'s slug to the parameterized title' do
            perform_action
            expect(blog_post.slug).to be == blog_post.title.parameterize
          end # it

          it 'clears the post\'s slug lock' do
            perform_action
            expect(blog_post.slug_lock).to be false
          end # it

          context 'with a custom slug' do
            let(:slug) { 'custom-slug' }
            let(:attributes) { super().merge :slug => slug }

            it 'sets the post\'s slug' do
              perform_action
              expect(blog_post.slug).to be == slug
            end # it

            it 'sets the post\'s slug lock' do
              perform_action
              expect(blog_post.slug_lock).to be true
            end # it
          end # context

          context 'with an empty slug' do
            let(:slug) { '' }
            let(:attributes) { super().merge :slug => slug }

            it 'sets the post\'s slug to the parameterized title' do
              perform_action
              expect(blog_post.slug).to be == blog_post.title.parameterize
            end # it

            it 'clears the post\'s slug lock' do
              perform_action
              expect(blog_post.slug_lock).to be false
            end # it
          end # context
        end # context
      end # describe

      describe 'import' do
        let(:attributes) do
          [*0..2].map { FactoryGirl.attributes_for(:blog_post) }
        end # let
        let(:data) { attributes.to_json }

        def perform_action
          post :import, :blog_posts => { :data => data }
        end # method perform_action

        context 'with invalid JSON' do
          let(:data) { '{}{}' }

          it 'responds with 200 ok and renders the import template' do
            perform_action
            expect(response.status).to be == 200
            expect(response).to render_template :import
          end # it
        end # context

        context 'with valid JSON but invalid posts' do
          let(:attributes) do
            super().tap do |ary|
              ary[0].update :title => nil
              ary[2].update :content_type => nil
            end # tap
          end # let

          it 'responds with 200 ok and renders the import template' do
            perform_action
            expect(response.status).to be == 200
            expect(response).to render_template :import
          end # it

          it 'does not create any posts' do
            expect {
              perform_action
            }.not_to change(BlogPost, :count)
          end # it
        end # context

        context 'with valid JSON' do
          it 'redirects to the blog path' do
            perform_action
            expect(response.status).to be == 302
            expect(response).to redirect_to admin_blog_path
          end # it

          it 'creates new posts' do
            expect {
              perform_action
            }.to change(BlogPost, :count).to(attributes.count)
          end # it
        end # context
      end # describe
    end # context

    context 'with a blog post' do
      let!(:blog_post) { FactoryGirl.create :blog_post }

      def perform_action
        get :index, :format => :json
      end # method perform_action

      describe 'index.json' do
        render_views

        let(:ary) { JSON.parse(response.body) }
        let(:hsh) { ary.first }
        
        it 'returns a JSON array containing the post encoded as JSON' do
          perform_action
          expect(response.status).to be == 200
          expect(ary.count).to be 1

          expect(hsh['author']).to be_a Hash
          expect(hsh['author']['email']).to be == blog_post.author.email

          expect(hsh['blog']).to be_a Hash
          expect(hsh['blog']['title']).to be == blog_post.blog.title

          %w(title content content_type).each do |field|
            expect(hsh[field]).to be == blog_post.send(field)
          end # each

          expect(hsh['published_at']).to be == 'null'
        end # it
      end # describe

      describe 'show.json' do
        render_views

        let(:hsh) { JSON.parse response.body }

        def perform_action
          get :show, :id => blog_post.id, :format => :json
        end # method perform_action

        it 'returns the post encoded as JSON' do
          perform_action
          expect(response.status).to be == 200
          expect(hsh).to be_a Hash

          expect(hsh['author']).to be_a Hash
          expect(hsh['author']['email']).to be == blog_post.author.email

          expect(hsh['blog']).to be_a Hash
          expect(hsh['blog']['title']).to be == blog_post.blog.title

          %w(title content content_type).each do |field|
            expect(hsh[field]).to be == blog_post.send(field)
          end # each

          expect(hsh['published_at']).to be == 'null'
        end # it

        context 'with a published post' do
          let(:blog_post) { super().tap &:publish }

          before(:each) { perform_action }

          it { expect(hsh['published_at']).to be == blog_post.published_at.utc.iso8601 }
        end # context
      end # describe
      
      describe 'update' do
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

          it 'updates the slug' do
            expect {
              perform_action
              blog_post.reload
            }.to change(blog_post, :slug).to(title.parameterize)
          end # it

          context 'with a slug value' do
            let(:slug) { 'custom-slug' }
            let(:attributes) { super().merge :slug => slug }

            it 'updates the slug' do
              expect {
                perform_action
                blog_post.reload
              }.to change(blog_post, :slug).to(slug)
            end # it 

            it 'sets the slug lock' do
              expect {
                perform_action
                blog_post.reload
              }.to change(blog_post, :slug_lock).to(true)
            end # it
          end # context

          context 'with a locked slug' do
            before(:each) do
              blog_post.slug = 'locked-slug'
              blog_post.save!
            end # before each

            it 'does not update the slug' do
              expect {
                perform_action
                blog_post.reload
              }.not_to change(blog_post, :slug)
            end # it

            context 'with an empty value for the slug' do
              let(:attributes) { super().merge :slug => '' }

              it 'sets the slug to the parameterized title' do
                expect {
                  perform_action
                  blog_post.reload
                }.to change(blog_post, :slug).to(title.parameterize)
              end # it

              it 'clears the slug lock' do
                expect {
                  perform_action
                  blog_post.reload
                }.to change(blog_post, :slug_lock).to(false)
              end # it
            end # context
          end # context
        end # context
      end # describe

      describe 'destroy' do
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

      describe 'publish' do
        def perform_action
          patch :publish, :id => blog_post.id
        end # method perform_action

        context 'with an invalid record' do
          before(:each) { blog_post.update_attribute :content_type, nil }

          it 'responds with 200 ok and renders the edit template' do
            perform_action
            expect(response.status).to be == 200
            expect(response).to render_template 'edit'
          end # it

          it 'does not publish the post' do
            expect {
              perform_action
              blog_post.reload
            }.not_to change(blog_post, :published?)
          end # it
        end # context

        context 'with a valid record' do
          it 'redirects to the admin show post path' do
            perform_action
            expect(response.status).to be == 302
            expect(response).to redirect_to admin_blog_post_path(blog_post)
          end # it

          it 'publishes the post' do
            expect {
              perform_action
              blog_post.reload
            }.to change(blog_post, :published?).to true
          end # it
        end # context
      end # describe
    end # context

    context 'with many blog posts' do
      let(:blog) { FactoryGirl.create :blog }
      before(:each) { 3.times { FactoryGirl.create :blog_post, :blog => blog } }

      describe 'index.json' do
        render_views

        let(:ary) { JSON.parse(response.body) }
        
        it 'returns a JSON array containing one item for each post' do
          get :index, :format => :json
          expect(response.status).to be == 200
          expect(ary.count).to be == blog.posts.count
        end # it
      end # describe
    end # context
  end # context
end # describe
