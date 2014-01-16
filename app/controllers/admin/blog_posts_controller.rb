# app/controllers/admin/blog_posts_controller.rb

class Admin::BlogPostsController < Admin::AdminController
  before_action :load_dependent_resources
  before_action :build_resource, :only => %i(new create)
  before_action :load_resource, :only => %i(show edit update)

  # POST /admin/blog/posts
  def create
    if @blog_post.save
      flash[:notice] = I18n.t('admin.blog_posts.new.success')
      redirect_to admin_blog_post_path(@blog_post)
    else
      breadcrumbs_for :new
      render :new
    end # if-else
  end # action create

  # GET /admin/blog/posts/:id/edit
  def edit
    breadcrumbs_for :edit
  end # action edit

  # GET /admin/blog/posts
  def index
    redirect_to admin_blog_path
  end # action index

  # GET /admin/blog/posts/new
  def new
    breadcrumbs_for :new
  end # action new

  # GET /admin/blog/posts/:id
  def show
    @blog_post_presenter = BlogPostPresenter.new @blog_post

    breadcrumbs_for :show
  end # action show

  # PATCH /admin/blog/posts/:id
  def update
    if @blog_post.update_attributes params[:blog_post]
      flash[:notice] = I18n.t('admin.blog_posts.edit.success')
      redirect_to admin_blog_post_path(@blog_post)
    else
      breadcrumbs_for :edit
      render :edit
    end
  end # action update

  private

  def breadcrumbs_for action
    @breadcrumbs << [I18n.t('admin.blog.breadcrumb'), admin_blog_path]
    case action
    when :new
      @breadcrumbs << [I18n.t('admin.blog_posts.breadcrumb')]
      @breadcrumbs << [I18n.t('admin.blog_posts.new.breadcrumb')]
    when :show
      @breadcrumbs << [I18n.t('admin.blog_posts.breadcrumb')]
      @breadcrumbs << [@blog_post.title]
    when :edit
      @breadcrumbs << [I18n.t('admin.blog_posts.breadcrumb')]
      @breadcrumbs << [@blog_post.title, admin_blog_post_path(@blog_post)]
      @breadcrumbs << [I18n.t('admin.blog_posts.edit.breadcrumb')]
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

  def load_resource
    @blog_post = BlogPost.find params[:id]
  end # method load_resource
end # class
