# app/controllers/admin/settings_controller.rb

class Admin::SettingsController < Admin::AdminController
  before_action :update_breadcrumbs
  before_action :load_resources, :only => %i(show update)

  # GET /admin/settings
  def show
    if @settings.blank?
      flash.now[:alert] = I18n.t('admin.settings.edit.failure.bootstrap')
    end # if
  end # action show

  # PATCH /admin/settings
  def update
    if @settings.blank?
      flash.now[:alert] = I18n.t('admin.settings.edit.failure.bootstrap')
      render :show and return
    end # if

    result = @settings.inject(true) do |memo, setting|
      if params['settings'].has_key? setting.name
        memo &&= setting.update_attributes :value => setting.cast_value(params['settings'][setting.name])
      end # if
    end # result

    if result
      flash[:notice] = 'Settings were successfully updated.'
      redirect_to admin_settings_path
    else
      render :show
    end # if-else
  end # action update

  private

  def load_resources
    @settings = Setting.all.to_a
  end # method load_resources

  def update_breadcrumbs
    @breadcrumbs << [I18n.t('admin.settings.breadcrumb')]
  end # method update_breadcrumbs
end # controller
