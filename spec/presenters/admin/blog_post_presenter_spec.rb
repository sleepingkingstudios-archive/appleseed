# spec/presenters/admin/blog_posts_presenter_spec.rb

require 'spec_helper'

RSpec.describe Admin::BlogPostPresenter do
  let(:attributes) { {} }
  let(:blog_post)  { FactoryGirl.build :blog_post, attributes }
  let(:instance)   { described_class.new blog_post }

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
