# app/models/blog.rb

class Blog
  include Mongoid::Document

  field :title, :type => String

  validates :title, :presence => true
end # class
