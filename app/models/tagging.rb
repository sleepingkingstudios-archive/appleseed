# app/models/tagging.rb

require 'mongoid/sleeping_king_studios/sluggable'

class Tagging
  include Mongoid::Document
  include Mongoid::SleepingKingStudios::Sluggable

  belongs_to :taggable, :polymorphic => true

  field :name, :type => String

  slugify :name

  validates :name,        :presence => true
  validates :taggable_id, :presence => true
end # model Tagging
