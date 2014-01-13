module Admin::SettingsHelper
  def boolean_setting_tag name, options = {}
    raw_value = value_for_name(name)
    checked   = !raw_value.blank? && raw_value.to_s != 'false'
    check_box_tag input_name(name), 1, checked, options
  end # method boolean_settings_tag

  def hidden_setting_tag name, value, options = {}
    hidden_field_tag input_name(name), value, options
  end # method hidden_setting_tag

  def setting_label_tag name, value, options = {}
    label_tag input_name(name), value, options
  end # method label_setting_tag

  def string_setting_tag name, options = {}
    text_field_tag input_name(name), value_for_name(name), options
  end # method string_setting_tag

  private

  def input_name name
    :"settings[#{name}]"
  end # method input_name

  def value_for_name name
    if !params['settings'].blank? && params['settings'].has_key?(name)
      params['settings'][name]
    elsif setting = @settings.select { |setting| setting.name == name.to_s }.first
      setting.value
    else
      nil
    end # if-elsif-else
  end # method value_for_name
end # module
