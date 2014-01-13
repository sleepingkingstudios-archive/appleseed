# app/controllers/admin/admin_controller.rb

class Admin::AdminController < ApplicationController
  before_action :authenticate_user!

  private

  def initialize_breadcrumbs
    super

    @breadcrumbs << [I18n.t('admin.breadcrumb')]
  end # method initialize_breadcrumbs
end # controller
