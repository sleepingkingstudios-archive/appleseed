# app/controllers/blogs_controller.rb

class BlogsController < ApplicationController
  before_action :load_resource

  # GET /blog
  def show
    @breadcrumbs << ['Blog']
    
    if @blog
      render :show
    else
      redirect_to :root
    end # if
  end # action show

  private

  def load_resource
    @blog = Blog.first
  end # method load_resource
end # controller
