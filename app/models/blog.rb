# app/models/blog.rb

class Blog
  include Mongoid::Document

  has_many :posts, :class_name => 'BlogPost', :dependent => :destroy

  field :title, :type => String

  validates :title, :presence => true

  def to_builder
    Jbuilder.new do |blog|
      blog.title title
    end # builder
  end # method to_builder
end # class
