# app/controllers/admin/users/registrations_controller.rb

class Admin::Users::RegistrationsController < Devise::RegistrationsController
  before_filter :allow_user_registration?, only: %i(new create)

  private

  def allow_user_registration?
    return if Setting.fetch(:allow_user_registration?, false) || 0 == User.count

    flash[:notice] = I18n.t 'devise.failure.registration_closed'
    redirect_to :root
  end # method allow_user_registration?
end # class
