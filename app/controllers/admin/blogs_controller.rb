# app/controllers/admin/blogs_controller.rb

class Admin::BlogsController < Admin::AdminController
  before_action :build_resource, :only => %i(new create)
  before_action :load_resource,  :only => %i(show edit update destroy)
  before_action :load_associations, :only => %i(show)

  # POST /admin/blog
  def create
    if 0 < Blog.count
      flash[:notice] = I18n.t('admin.blog.failure.blog_already_exists')
      redirect_to admin_blog_path
    elsif @blog.save
      flash[:notice] = I18n.t('admin.blog.new.success')
      redirect_to admin_blog_path
    else
      breadcrumbs_for :new
      render :new
    end # if-elsif-else
  end # action create

  # DELETE /admin/blog
  def destroy
    if 0 == Blog.count
      flash[:notice] = I18n.t('admin.blog.failure.blog_does_not_exist', :action => t('admin.blog.delete.action'))
    else
      flash[:alert] = I18n.t('admin.blog.delete.success')
      @blog.destroy
    end # if

    redirect_to admin_blog_path
  end # action destroy

  # GET /admin/blog/edit
  def edit
    if 0 == Blog.count
      flash[:notice] = I18n.t('admin.blog.failure.blog_does_not_exist', :action => t('admin.blog.edit.action'))
      redirect_to admin_blog_path
    else
      breadcrumbs_for :edit
      render :edit
    end # if-else
  end # action edit

  # GET /admin/blog/new
  def new
    if 0 < Blog.count
      flash[:notice] = I18n.t('admin.blog.failure.blog_already_exists', :action => t('admin.blog.new.action'))
      redirect_to admin_blog_path and return
    end # if

    breadcrumbs_for :new    
  end # action new

  # GET /admin/blog
  def show
    breadcrumbs_for :show
  end # action show

  # PATCH /admin/blog
  def update
    if 0 == Blog.count
      flash[:notice] = I18n.t('admin.blog.failure.blog_does_not_exist', :action => t('admin.blog.edit.title').downcase)
      redirect_to admin_blog_path
    elsif @blog.update_attributes blog_params
      flash[:notice] = I18n.t('admin.blog.edit.success')
      redirect_to admin_blog_path
    else
      breadcrumbs_for :edit
      render :edit
    end # if-elsif-else
  end # action update

  private

  def blog_params
    params.fetch(:blog, {}).permit(:title)
  end # method blog_params

  def breadcrumbs_for action
    case action
    when :show
      @breadcrumbs << [I18n.t('admin.blog.breadcrumb')]
    when :new
      @breadcrumbs << [I18n.t('admin.blog.breadcrumb'), admin_blog_path]
      @breadcrumbs << [I18n.t('admin.blog.new.breadcrumb')]
    when :edit
      @breadcrumbs << [I18n.t('admin.blog.breadcrumb'), admin_blog_path]
      @breadcrumbs << [I18n.t('admin.blog.edit.breadcrumb')]
    end # case
  end # method breadcrumbs_for

  def build_resource
    @blog = Blog.new blog_params
  end # method build_resource

  def load_associations
    @blog_posts = @blog ? @blog.posts.asc(:most_recent_order) : []
  end # method load_associations

  def load_resource
    @blog = Blog.first
  end # method load_resources
end # class
