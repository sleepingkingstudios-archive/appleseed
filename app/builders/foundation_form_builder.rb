# app/builders/foundation_form_builder.rb

class FoundationFormBuilder < ActionView::Helpers::FormBuilder
  %i(email_field password_field text_field).each do |field_type|
    define_method field_type do |method, options = {}|
      postfix = ''

      if has_error(method)
        add_class(options, 'error')
        postfix = '<small class="error">Invalid Entry</small>'.html_safe
      end # if

      super(method, options) + postfix
    end # method
  end # each

  def label method, text = nil, options = {}, &block
    add_class(options, 'error') if has_error(method)

    super
  end # method label

  private

  def add_class options, class_name
    options ||= {}
    options[:class].blank? ?
      options[:class] = class_name :
      options[:class] += " #{class_name}"
  end # method add_class

  def has_error method
    return false unless object.respond_to?(:errors)
    object.errors.include? method
  end # method has_error
end # method 
