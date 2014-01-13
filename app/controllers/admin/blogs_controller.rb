# app/controllers/admin/blogs_controller.rb

class Admin::BlogsController < Admin::AdminController
  before_action :build_resource, :only => %i(new create)
  before_action :load_resource,  :only => %i(show)

  # GET /admin/blog/new
  def new
    if 0 < Blog.count
      flash[:notice] = I18n.t('admin.blog.failure.blog_already_exists')
      redirect_to admin_blog_path and return
    end # if

    @breadcrumbs << [I18n.t('blog.breadcrumb'), admin_blog_path]
    @breadcrumbs << [I18n.t('admin.blog.new.breadcrumb')]
  end # action new

  # GET /admin/blog
  def show
    @breadcrumbs << [I18n.t('blog.breadcrumb')]
  end # action show

  # POST /admin/blog
  def create
    if 0 < Blog.count
      flash[:alert] = I18n.t('admin.blog.failure.blog_already_exists')
      redirect_to admin_blog_path
    elsif @blog.save
      redirect_to admin_blog_path
    else
      render :new
    end # if-elsif-else
  end # action create

  private

  def build_resource
    @blog = Blog.new params[:blog]
  end # method build_resource

  def load_resource
    @blog = Blog.first
  end # method load_resources
end # class
