# app/models/blog_post.rb

class BlogPost
  include Mongoid::Document

  CONTENT_TYPES = %w(plain)

  belongs_to :author, :class_name => 'User', :inverse_of => :posts
  belongs_to :blog

  field :title, :type => String

  field :content,      :type => String
  field :content_type, :type => String

  field :published_at, :type => DateTime

  scope :published, -> { where(:published_at.lte => DateTime.current) }

  validates :author, :presence => true
  validates :blog, :presence => true
  validates :title, :presence => true
  validates :content_type, :presence => true,
    :inclusion => { :in => CONTENT_TYPES }

  def publish
    self.published_at = DateTime.current
    self.save
  end # method publish

  def published?
    !self.published_at.blank? && self.published_at <= DateTime.now
  end # method published?
end # model
