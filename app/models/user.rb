# app/models/user.rb

class User
  include Mongoid::Document

  field :email, :type => String

  # Validations
  validates :email, :presence => true, :uniqueness => true
end # model
