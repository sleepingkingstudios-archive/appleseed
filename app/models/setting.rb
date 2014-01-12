# app/models/setting.rb

class Setting
  include Mongoid::Document

  TYPES                = %w(Boolean String)
  BOOLEAN_TRUE_STRINGS = %w(true 1)

  def self.fetch name, default = nil
    @cached_values ||= {}
    unless @cached_values.has_key? name
      setting = where(:name => name).first

      @cached_values[name] = setting.value unless setting.nil?
    end # if

    if !default.nil? && @cached_values[name].blank?
      default
    else
      @cached_values[name]
    end # if-else
  end # class method fetch

  def self.store name, value
    @cached_values ||= {}
    @cached_values[name] = value
  end # class method store

  field :name,  :type => String
  field :type,  :type => String
  field :value, :type => Object

  validates :name, :presence => true, :uniqueness => true
  validates :type, :presence => true, :inclusion => { :in => TYPES }

  def save options = {}
    Setting.store self.name, self.value if persisted = super

    return persisted
  end # method save

  def cast_value value
    case type
    when 'Boolean'
      case
      when value.nil?
        nil
      when true === value || false === value
        value
      when Integer === value
        0 != value
      when String === value
        !!(BOOLEAN_TRUE_STRINGS.include? value)
      else
        false
      end # case
    when 'String'
      case
      when value.nil?
        nil
      else
        value.to_s
      end # case
    else
      value
    end # case
  end # method cast_value
end # model
