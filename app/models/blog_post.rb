# app/models/blog_post.rb

require 'mongoid/sleeping_king_studios/orderable'

class BlogPost
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::SleepingKingStudios::Orderable

  CONTENT_TYPES = %w(plain)

  belongs_to :author, :class_name => 'User', :inverse_of => :posts
  belongs_to :blog

  field :title, :type => String

  field :content,      :type => String
  field :content_type, :type => String

  field :published_at, :type => Time

  scope :published, -> {
    where(:published_at.lte => Time.now.utc).asc(:published_order)
  }

  validates :author, :presence => true
  validates :blog, :presence => true
  validates :title, :presence => true
  validates :content_type, :presence => true,
    :inclusion => { :in => CONTENT_TYPES }

  cache_ordering :created_at.desc,   :as => :most_recent_order
  cache_ordering :published_at.desc, :as => :published_order,
    :filter => { :published_at.ne => nil }

  def publish
    self.published_at = Time.now.utc

    if self.save
      true
    else
      self.published_at = nil
      false
    end # if-else
  end # method publish

  def published?
    !self.published_at.blank? && self.published_at <= Time.now.utc
  end # method published?
end # model
