# spec/models/tagging_spec.rb

require 'spec_helper'

RSpec.describe Tagging do
  let(:traits)     { [] }
  let(:attributes) { FactoryGirl.attributes_for :tagging }
  let(:instance)   { FactoryGirl.build :tagging, *traits, attributes }

  describe '#name' do
    it { expect(instance).to have_property :name }
  end # describe

  describe '#slug' do
    it { expect(instance).to have_reader :slug }

    it 'parameterizes the name' do
      expect(instance.slug).to be == instance.to_slug
    end # it
  end # describe

  describe '#taggable' do
    it { expect(instance).to have_reader :taggable }
    it { expect(instance.taggable).to be nil }

    context 'with a blog post' do
      let(:blog_post)  { FactoryGirl.create :blog_post }
      let(:attributes) { super().merge :taggable => blog_post }

      it { expect(instance.taggable).to be == blog_post }
    end # context
  end

  describe '#validation' do
    let(:blog_post)  { FactoryGirl.create :blog_post }
    let(:attributes) { super().merge :taggable_id => blog_post.id }

    it { expect(instance).to be_valid }

    describe 'name must be present' do
      let(:attributes) { super().merge :name => nil }

      it { expect(instance).to have_errors.on(:name).with_message("can't be blank") }
    end # describe

    describe 'taggable_id must be present' do
      let(:attributes) { super().merge :taggable_id => nil }

      it { expect(instance).to have_errors.on(:taggable_id).with_message("can't be blank") }
    end # describe
  end # describe
end # describe
