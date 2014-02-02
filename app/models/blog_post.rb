# app/models/blog_post.rb

require 'mongoid/sleeping_king_studios/orderable'
require 'mongoid/sleeping_king_studios/sluggable'

class BlogPost
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::SleepingKingStudios::Orderable
  include Mongoid::SleepingKingStudios::Sluggable

  CONTENT_TYPES = %w(plain redcarpet)

  belongs_to :author, :class_name => 'User', :inverse_of => :posts
  belongs_to :blog

  field :title, :type => String

  field :content,      :type => String
  field :content_type, :type => String

  field :published_at, :type => Time

  scope :published, -> {
    where(:published_at.lte => Time.now.utc).desc(:published_order)
  } # end scope

  slugify :title, :lockable => true

  validates :author, :presence => true
  validates :blog, :presence => true
  validates :title, :presence => true
  validates :content_type, :presence => true,
    :inclusion => { :in => CONTENT_TYPES }

  cache_ordering :created_at.desc,  :as => :most_recent_order
  cache_ordering :published_at.asc, :as => :published_order,
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

  ########################
  ### ORDERING HELPERS ###
  ########################

  def first_most_recent
    BlogPost.first_most_recent(BlogPost.where(:blog_id => blog.id))
  end # method first_most_recent

  def last_most_recent
    BlogPost.last_most_recent(BlogPost.where(:blog_id => blog.id))
  end # method last_most_recent

  def next_most_recent
    super BlogPost.where(:blog_id => blog.id)
  end # method next_most_recent

  def prev_most_recent
    super BlogPost.where(:blog_id => blog.id)
  end # method prev_most_recent

  def first_published
    BlogPost.first_published(BlogPost.where(:blog_id => blog.id))
  end # method first_published

  def last_published
    BlogPost.last_published(BlogPost.where(:blog_id => blog.id))
  end # method first_published

  def next_published
    super BlogPost.where(:blog_id => blog.id)
  end # method next_published

  def prev_published
    super BlogPost.where(:blog_id => blog.id)
  end # method prev_published
end # model
