class BlogTagsController < ApplicationController
  before_action :load_dependent_resources
  before_action :load_resources, :only => %i(show)

  def show
    breadcrumbs_for :show
  end # action show

  private

  def breadcrumbs_for action
    @breadcrumbs << [I18n.t('blog.breadcrumb'), blog_path]
    case action
    when :show
      @breadcrumbs << [I18n.t('blog_tags.breadcrumb')]
      @breadcrumbs << [@taggings.first.name]
    end # case
  end # method breadcrumbs_for

  def load_dependent_resources
    @blog = Blog.first
  end # method load_dependent_resources

  def load_resources
    @taggings   = Tagging.where(:slug => params[:id])
    post_ids    = @taggings.select do |tagging|
      "BlogPost" == tagging.taggable_type
    end.map(&:taggable_id).uniq
    @blog_posts = BlogPost.find(post_ids).select &:published?
  end # method load_resource
end
