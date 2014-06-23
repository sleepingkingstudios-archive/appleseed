# app/controllers/pages_controller.rb

class PagesController < ApplicationController
  # GET /about
  def about
    @breadcrumbs << [I18n.t('pages.about.breadcrumb')]
  end # action about

  # GET /about/me
  def about_me
    @breadcrumbs << [I18n.t('pages.about.breadcrumb'), about_path]
    @breadcrumbs << [I18n.t('pages.about.me.breadcrumb')]
  end # action about_me

  # GET /
  def index
    @breadcrumbs = nil
  end # action index

  def projects
    @breadcrumbs << [I18n.t('pages.projects.breadcrumb')]
  end # action projects
end # controller
