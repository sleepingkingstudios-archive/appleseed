# app/models/blog_post.rb

class BlogPost
  include Mongoid::Document

  CONTENT_TYPES = %w(plain)

  belongs_to :author, :class_name => 'User', :inverse_of => :posts
  belongs_to :blog

  field :title, :type => String

  field :content,      :type => String
  field :content_type, :type => String

  validates :author, :presence => true
  validates :blog, :presence => true
  validates :title, :presence => true
  validates :content_type, :presence => true,
    :inclusion => { :in => CONTENT_TYPES }

  def render_content
    case content_type
    when 'plain'
      content
    end # case
  end # method render_content
end # model
