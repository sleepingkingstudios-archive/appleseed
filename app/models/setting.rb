# app/models/setting.rb

class Setting
  include Mongoid::Document

  TYPES                = %w(Boolean String)
  BOOLEAN_TRUE_STRINGS = %w(true 1)

  class << self
    def cache
      @cached_values ||= {}.with_indifferent_access
    end # class method cached_values

    def fetch name, default = nil
      values = cache
      unless values.has_key? name
        setting = where(:name => name).first

        values[name] = setting.value unless setting.nil?
      end # if

      values[name].blank? && !default.nil? ? default : values[name]
    end # class method fetch

    def purge_cache!
      @cached_values = {}.with_indifferent_access
    end # class method purge_cache!

    def store name, value
      cache[name] = value
    end # class method store
  end # metaclass

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
