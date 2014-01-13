class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :initialize_breadcrumbs

  private

  def authenticate_user!
    unless user_signed_in?
      flash[:alert] = I18n.t 'devise.failure.unauthorized_action'
      redirect_to :root
    end # unless
  end # method authenticate_user

  def initialize_breadcrumbs
    @breadcrumbs = [['Home', root_path]]
  end # method initialize_breadcrumbs
end # controller
