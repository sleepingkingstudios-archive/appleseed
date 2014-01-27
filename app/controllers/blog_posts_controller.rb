# app/controllers/blog_posts_controller.rb

class BlogPostsController < ApplicationController
  before_action :load_dependent_resources
  before_action :load_resource, :only => %i(show)

  # GET /blog/posts/:id
  def show
    breadcrumbs_for :show

    @blog_post_presenter = BlogPostPresenter.new @blog_post
  end # method show

  private

  def breadcrumbs_for action
    @breadcrumbs << [I18n.t('blog.breadcrumb'), blog_path]
    case action
    when :show
      @breadcrumbs << [@blog_post.title]
    end # case
  end # method breadcrumbs_for

  def load_dependent_resources
    @blog = Blog.first
  end # method load_dependent_resources

  def load_resource
    @blog_post = BlogPost.find params[:id]
  end # method load_resource
end # class
