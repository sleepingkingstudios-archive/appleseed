class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def authenticate_user!
    unless current_user
      flash[:alert] = 'You are not authorized to perform that action.'
      redirect_to :root
    end # unless
  end # method authenticate_user
end # controller
