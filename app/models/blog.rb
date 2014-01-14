# app/models/blog.rb

class Blog
  include Mongoid::Document

  has_many :posts, :class_name => 'BlogPost'

  field :title, :type => String

  validates :title, :presence => true
end # class
