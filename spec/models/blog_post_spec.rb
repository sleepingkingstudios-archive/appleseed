# spec/models/blog_post_spec.rb

require 'spec_helper'

RSpec.describe BlogPost do
  let(:attributes) { {} }
  let(:instance) { FactoryGirl.build :blog_post, attributes }

  describe '::CONTENT_TYPES' do
    it { expect(described_class::CONTENT_TYPES).to be_a Array }

    %w(plain redcarpet).each do |type|
      it { expect(described_class::CONTENT_TYPES).to include type }
    end # each
  end # describe

  describe '::published scope' do
    let(:records) { described_class.published.to_a }

    before(:each) { instance.save! }

    it { expect(described_class).to respond_to(:published) }
    it { expect(described_class.published).to be_a Mongoid::Criteria }

    context 'with an unpublished post' do
      it { expect(records).not_to include instance }
    end # context

    context 'with a post published in the past' do
      let(:attributes) { super().merge :published_at => 1.day.ago }

      it { expect(records).to include instance }
    end # context

    context 'with a post published in the future' do
      let(:attributes) { super().merge :published_at => 1.day.from_now }

      it { expect(records).not_to include instance }
    end # context
  end # describe

  describe '#author' do
    it { expect(instance).to respond_to(:author) }
    it { expect(instance.author).to be_a User }
  end # describe

  describe '#blog' do
    it { expect(instance).to respond_to(:blog) }
    it { expect(instance.blog).to be_a Blog }
  end # describe

  describe '#content' do
    it { expect(instance).to have_property(:content) }
  end # describe

  describe '#content_type' do
    it { expect(instance).to have_property(:content_type) }
  end # describe

  describe '#created_at' do
    it { expect(instance).to have_property(:created_at) }
    it { expect(instance.created_at).to be nil }

    describe '#save' do
      it 'updates the value' do
        expect {
          instance.save
          instance.reload
        }.to change(instance, :created_at).to(be_a ActiveSupport::TimeWithZone)
      end # it
    end # describe
  end # describe

  describe '#most_recent_order' do
    it { expect(instance).to have_reader(:most_recent_order) }
    it { expect(instance.most_recent_order).to be nil }

    describe '#save' do
      it 'adds the record to the most recent ordering' do
        expect {
          instance.save
        }.to change(instance, :most_recent_order).to(be_a Integer)
      end # it
    end # describe
  end # describe

  describe '#published_at' do
    it { expect(instance).to have_property(:published_at) }
    it { expect(instance.published_at).to be nil }
  end # describe

  describe '#published_order' do
    it { expect(instance).to have_reader(:published_order) }
    it { expect(instance.published_order).to be nil }
  end # describe

  describe '#title' do
    it { expect(instance).to have_property(:title) }
  end # describe

  describe '#publish' do
    it { expect(instance).to respond_to(:publish).with(0).arguments }

    context 'with an invalid record' do
      let(:attributes) { super().merge :content_type => nil }

      it 'returns false' do
        expect(instance.publish).to be false
      end # it

      it 'does not update the published_at date' do
        expect {
          instance.publish
        }.not_to change(instance, :published_at)
      end # it

      it 'does not save the record' do
        expect {
          instance.publish
        }.not_to change(instance, :persisted?)
      end # it'
    end # context

    context 'with a valid record' do
      it 'returns true' do
        expect(instance.publish).to be true
      end # it

      it 'saves the record' do
        expect {
          instance.publish
        }.to change(instance, :persisted?).to(true)
      end # it

      it 'updates the published_at date' do
        expect {
          instance.publish
        }.to change(instance, :published_at).to(be_a ActiveSupport::TimeWithZone)
      end # it

      it 'adds the record to the published ordering' do
        expect {
          instance.publish
        }.to change(instance, :published_order).to(be_a Integer)
      end # it
    end # context
  end # describe

  describe '#published?' do
    it { expect(instance).to respond_to(:published?).with(0).arguments }
    it { expect(instance.published?).to be false }

    context 'with a post published in the past' do
      let(:attributes) { super().merge :published_at => 1.day.ago }

      it { expect(instance.published?).to be true }
    end # context

    context 'with a post published in the future' do
      let(:attributes) { super().merge :published_at => 1.day.from_now }

      it { expect(instance.published?).to be false }
    end # context
  end # describe

  describe '#to_builder' do
    it { expect(instance).to respond_to(:to_builder).with(0).arguments }
    it { expect(instance.to_builder).to be_a Jbuilder }
    it 'generates parsable JSON' do
      expect { JSON.parse instance.to_builder.target! }.not_to raise_error
    end # it

    context 'with generated JSON' do
      let(:json) { instance.to_builder.target! }
      let(:hsh)  { JSON.parse json }

      it { expect(hsh['author']).to be_a Hash }
      it { expect(hsh['author']['email']).to be == instance.author.email }

      it { expect(hsh['blog']).to be_a Hash }
      it { expect(hsh['blog']['title']).to be == instance.blog.title }

      %w(title content content_type).each do |field|
        it { expect(hsh[field]).to be == instance.send(field) }
      end # each

      it { expect(hsh['published_at']).to be == 'null' }

      context 'with a published post' do
        before(:each) { instance.publish }

        it { expect(hsh['published_at']).to be == instance.published_at.utc.iso8601 }
      end # context
    end # context
  end # describe

  describe 'validation' do
    it { expect(instance).to be_valid }

    describe 'author must be present' do
      let(:attributes) { super().merge :author => nil }

      it { expect(instance).to have_errors.on(:author).with_message('can\'t be blank') }
    end # describe

    describe 'blog must be present' do
      let(:attributes) { super().merge :blog => nil }

      it { expect(instance).to have_errors.on(:blog).with_message('can\'t be blank') }
    end # describe

    describe 'content type must be present' do
      let(:attributes) { super().merge :content_type => nil }

      it { expect(instance).to have_errors.on(:content_type).with_message('can\'t be blank') }
    end # describe

    describe 'content type must be in CONTENT_TYPES' do
      let(:attributes) { super().merge :content_type => 'gibberish' }

      it { expect(instance).to have_errors.on(:content_type).with_message('is not included in the list') }
    end # describe

    describe 'title must be present' do
      let(:attributes) { super().merge :title => nil }

      it { expect(instance).to have_errors.on(:title).with_message('can\'t be blank') }
    end # describe
  end # describe
end # describe
