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

  def projects
    @breadcrumbs << [I18n.t('pages.projects.breadcrumb')]
  end # action projects
end # controller
