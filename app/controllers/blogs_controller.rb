# app/controllers/blogs_controller.rb

class BlogsController < ApplicationController
  before_action :load_resources

  # GET /blog
  def show
    @blog_post_presenter = BlogPostPresenter.new @blog_post
    @breadcrumbs << [I18n.t('blog.breadcrumb')]
    
    if @blog
      render :show
    else
      redirect_to :root
    end # if
  end # action show

  private

  def load_resources
    @blog = Blog.first
    @blog_post = @blog ? @blog.posts.published.limit(1).first : nil
  end # method load_resources
end # controller
