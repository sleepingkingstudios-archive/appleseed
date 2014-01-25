# app/controllers/pages_controller.rb

class PagesController < ApplicationController
  # GET /about
  def about
    @breadcrumbs << [I18n.t('pages.about.breadcrumb')]
  end # action about

  # GET /
  def index
    @breadcrumbs = nil
  end # action index
end # controller
