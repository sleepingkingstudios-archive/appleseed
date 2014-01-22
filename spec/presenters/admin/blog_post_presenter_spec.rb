# spec/presenters/admin/blog_posts_presenter_spec.rb

require 'spec_helper'

RSpec.describe Admin::BlogPostPresenter do
  let(:attributes) { {} }
  let(:blog_post)  { FactoryGirl.build :blog_post, attributes }
  let(:instance)   { described_class.new blog_post }

  describe '#published_date' do
    it { expect(instance).to respond_to(:published_date).with(0, :format).arguments }

    context 'with an unpublished post' do
      it { expect(instance.published_date).to be nil }
    end # context

    context 'with a published post' do
      let(:published_at) { Time.now.utc }

      before(:each) do
        allow(instance).to receive(:published?).and_return(true)
        allow(instance).to receive(:published_at).and_return(published_at)
      end # before each

      it { expect(instance.published_date).to be == I18n.l(published_at, :format => :long) }

      context 'with a format argument' do
        let(:format) { :short }

        it { expect(instance.published_date format: format).to be == I18n.l(published_at, :format => format) }
      end # context
    end # context
  end # describe

  describe '#published_mark' do
    it { expect(instance).to respond_to(:published_mark).with(0).arguments }

    context 'with an unpublished post' do
      it { expect(instance.published_mark).to be == '<i class="fi-x alert"></i>' }
    end # context

    context 'with a published post' do
      before(:each) do
        allow(instance).to receive(:published?).and_return(true)
      end # before each

      it { expect(instance.published_mark).to be == '<i class="fi-check success"></i>' }
    end # context
  end # describe
end # describe
