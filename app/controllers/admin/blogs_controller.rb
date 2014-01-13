# app/controllers/admin/blogs_controller.rb

class Admin::BlogsController < Admin::AdminController
  before_action :load_resource, :only => %i(show)

  # GET /admin/blog
  def show
    @breadcrumbs << [I18n.t('blog.breadcrumb')]
  end # action show

  private

  def load_resource
    @blog = Blog.first
  end # method load_resources
end # class
