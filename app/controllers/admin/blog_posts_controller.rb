# app/controllers/admin/blog_posts_controller.rb

class Admin::BlogPostsController < Admin::AdminController
  before_action :load_dependent_resources
  before_action :build_resource, :only => %i(new create)

  def create
    if @blog_post.save
      flash[:notice] = I18n.t('admin.blog_posts.new.success')
      redirect_to admin_blog_path
    else
      breadcrumbs_for :new
      render :new
    end # if-else
  end # action create

  # GET /admin/blog/posts/new
  def new
    breadcrumbs_for :new
  end # action new

  private

  def breadcrumbs_for action
    @breadcrumbs << [I18n.t('admin.blog.breadcrumb'), admin_blog_path]
    case action
    when :new
      @breadcrumbs << [I18n.t('admin.blog_posts.breadcrumb')]
      @breadcrumbs << [I18n.t('admin.blog_posts.new.breadcrumb')]
    end # case
  end # method breadcrumbs_for

  def build_resource
    @blog_post = BlogPost.new params[:blog_post]
    @blog_post.author = current_user
    @blog_post.blog   = @blog
    @blog_post
  end # method build_resource

  def load_dependent_resources
    @blog = Blog.first
  end # method load_dependent_resources
end # class
