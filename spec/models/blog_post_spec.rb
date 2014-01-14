# spec/models/blog_post_spec.rb

require 'spec_helper'

RSpec.describe BlogPost do
  let(:attributes) { {} }
  let(:instance) { FactoryGirl.build :blog_post, attributes }

  describe '::CONTENT_TYPES' do
    it { expect(described_class::CONTENT_TYPES).to be_a Array }

    %w(plain).each do |type|
      it { expect(described_class::CONTENT_TYPES).to include type }
    end # each
  end # describe

  describe '#content' do
    it { expect(instance).to have_property(:content) }
  end # describe

  describe '#content_type' do
    it { expect(instance).to have_property(:content_type) }
  end # describe

  describe '#title' do
    it { expect(instance).to have_property(:title) }
  end # describe

  describe '#render_content' do
    it { expect(instance).to respond_to(:render_content).with(0).arguments }

    context 'with a plain text content' do
      let(:content_type) { 'plain' }
      let(:content) do
        "It little profits that an idle king,\n" +
        "By this still hearth, among these barren crags,\n" +
        "Match'd with an aged wife I mete and dole\n" +
        "Unequal laws unto a savage race\n" +
        "That hoard, and sleep, and feed, and know not me."
      end # let
      let(:attributes) do
        super().merge :content_type => content_type, :content => content
      end # let

      it 'returns the content unfiltered' do
        expect(instance.render_content).to be == content
      end # it
    end # context
  end # describe

  describe '#blog' do
    it { expect(instance).to respond_to(:blog) }
    it { expect(instance.blog).to be_a Blog }
  end # describe

  describe 'validation' do
    it { expect(instance).to be_valid }

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
