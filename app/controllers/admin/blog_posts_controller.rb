# app/controllers/admin/blog_posts_controller.rb

class Admin::BlogPostsController < Admin::AdminController
  before_action :load_dependent_resources
  before_action :build_resource, :only => %i(new create)
  before_action :load_resource, :only => %i(show edit update destroy publish)

  # POST /admin/blog/posts
  def create
    if @blog_post.save && update_taggings
      flash[:notice] = I18n.t('admin.blog_posts.new.success')
      redirect_to admin_blog_post_path(@blog_post)
    else
      breadcrumbs_for :new
      render :new
    end # if-else
  end # action create

  # DELETE /admin/blog/posts/:id
  def destroy
    @blog_post.destroy

    flash[:alert] = I18n.t('admin.blog_posts.delete.success')
    redirect_to admin_blog_path
  end # action destroy

  # GET /admin/blog/posts/:id/edit
  def edit
    breadcrumbs_for :edit
  end # action edit

  # GET /admin/blog/posts/import
  # POST /admin/blog/posts/import
  def import
    if request.get?
      @blog_posts = []
      breadcrumbs_for :import
      render :import and return
    elsif blog_posts_params.nil?
      flash.now[:alert] = I18n.t('admin.blog_posts.import.failure.malformed_json')
      breadcrumbs_for :import
      render :import and return
    end # if-elsif

    build_resources

    if @blog_posts.map(&:valid?).inject(true) { |memo, valid| memo && valid }
      BlogPost.collection.insert(@blog_posts.map &:as_document)
      flash[:notice] = I18n.t('admin.blog_posts.import.success')
      redirect_to admin_blog_path
    else
      flash.now[:alert] = I18n.t('admin.blog_posts.import.failure.invalid_posts')
      breadcrumbs_for :import
      render :import
    end # if-else
  end # action import

  # GET /admin/blog/posts
  def index
    respond_to do |format|
      format.html { redirect_to admin_blog_path }
      format.json do
        load_dependent_resources
        load_resources

        render :index
      end # format
    end # respond_to
  end # action index

  # GET /admin/blog/posts/new
  def new
    breadcrumbs_for :new
  end # action new

  # POST /admin/blog/posts/preview
  # GET  /admin/blog/posts/:id/preview
  def preview
    params[:id] ? load_resource : build_resource

    # Stub taggings.
    @blog_post.taggings = taggings_params.map do |tagging_name|
      Tagging.new :name => tagging_name
    end

    @blog_post_presenter = Admin::BlogPostPresenter.new @blog_post
    breadcrumbs_for :preview
  end # action preview

  # PATCH /admin/blog/posts/:id/publish
  def publish
    if @blog_post.publish
      flash[:notice] = I18n.t('admin.blog_posts.publish.success')
      redirect_to admin_blog_post_path(@blog_post)
    else
      breadcrumbs_for :edit
      render :edit
    end # if-else
  end # action publish

  # GET /admin/blog/posts/:id
  def show
    @blog_post_presenter = Admin::BlogPostPresenter.new @blog_post

    breadcrumbs_for :show
  end # action show

  # PATCH /admin/blog/posts/:id
  def update
    post_params = blog_post_params
    
    if false == post_params[:slug_lock]
      post_params[:slug] = BlogPost.value_to_slug(post_params.fetch('title', @blog_post.title))
    end # if

    if @blog_post.update_attributes(post_params) && update_taggings
      flash[:notice] = I18n.t('admin.blog_posts.edit.success')
      redirect_to admin_blog_post_path(@blog_post)
    else
      breadcrumbs_for :edit
      render :edit
    end
  end # action update

  private

  def blog_post_params
    hsh = params.fetch(:blog_post, {}).permit(:title, :slug, :content, :content_type)
    hsh[:slug_lock] = !hsh[:slug].blank? if hsh.has_key?(:slug)
    hsh
  end # method blog_post_params

  def blog_posts_data
    params.fetch(:blog_posts, {}).fetch(:data, nil)
  end # method blog_posts_data

  def blog_posts_params
    JSON.parse blog_posts_data
  rescue JSON::ParserError
    nil
  end # method blog_posts_params

  def breadcrumbs_for action
    @breadcrumbs << [I18n.t('admin.blog.breadcrumb'), admin_blog_path]
    case action
    when :import
      @breadcrumbs << [I18n.t('admin.blog_posts.breadcrumb')]
      @breadcrumbs << [I18n.t('admin.blog_posts.import.breadcrumb')]
    when :new
      @breadcrumbs << [I18n.t('admin.blog_posts.breadcrumb')]
      @breadcrumbs << [I18n.t('admin.blog_posts.new.breadcrumb')]
    when :preview
      @breadcrumbs << [I18n.t('admin.blog_posts.breadcrumb')]
      @breadcrumbs << [I18n.t('admin.blog_posts.preview.breadcrumb')]
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
    post_params = blog_post_params

    if false == post_params[:slug_lock]
      post_params[:slug] = BlogPost.value_to_slug(post_params.fetch('title', ''))
    end # if

    @blog_post = BlogPost.new post_params
    @blog_post.author = current_user
    @blog_post.blog   = @blog
    @blog_post
  end # method build_resource

  def build_resources
    @blog_posts = blog_posts_params.map do |params|
      blog_post = BlogPost.new params.select { |key, _| %w(title content content_type).include?(key) }
      blog_post.author = current_user
      blog_post.blog   = @blog
      blog_post
    end # map
  end # method build_resources

  def load_dependent_resources
    @blog = Blog.first
  end # method load_dependent_resources

  def load_resource
    @blog_post = BlogPost.find params[:id]
  end # method load_resource

  def load_resources
    @blog_posts = @blog ? @blog.posts : []
  end # method load_resources

  def taggings_params
    params.fetch(:blog_post, {}).fetch(:taggings, '').split(', ').map(&:strip).uniq
  end # method taggings_params

  def update_taggings
    names = Set.new(taggings_params)

    # Check for removed taggings.
    @blog_post.taggings.each do |tagging|
      if names.include?(tagging.name)
        # If the tagging exists and is in the set of names, remove the name so
        # that we do not create a duplicate later.
        names.delete tagging.name
      else
        # If the tagging exists and is not in the set of names, destroy the
        # tagging (and remove it from the taggings cached on the model object).
        @blog_post.taggings.delete tagging
        tagging.destroy
      end # if-else
    end # each

    names.each do |name|
      @blog_post.taggings.create :name => name
    end # each

    true
  end # method update_taggings
end # class
