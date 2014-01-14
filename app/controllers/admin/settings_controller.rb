# app/controllers/admin/settings_controller.rb

class Admin::SettingsController < Admin::AdminController
  before_action :update_breadcrumbs
  before_action :load_resources, :only => %i(show update)

  # GET /admin/settings
  def show; end

  # POST /admin/settings
  def update
    result = @settings.inject(true) do |memo, setting|
      if params['settings'].has_key? setting.name
        binding.pry if setting.name =~ /allow/
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
