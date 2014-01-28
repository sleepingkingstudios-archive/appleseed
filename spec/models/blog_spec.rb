# spec/models/blog_spec.rb

require 'spec_helper'

RSpec.describe Blog do
  let(:attributes) { {} }
  let(:instance) { FactoryGirl.build :blog, attributes }

  describe '#title' do
    it { expect(instance).to have_property(:title) }
  end # describe

  describe '#posts' do
    it { expect(instance).to respond_to(:posts).with(0).arguments }
    it { expect(instance.posts).to be_a Array }

    context 'with created posts' do
      before(:each) do
        instance.save!
        3.times { FactoryGirl.create :blog_post, :blog => instance }
      end # before each

      describe ':dependent => :destroy' do
        it 'destroys the blog posts' do
          expect {
            instance.destroy
          }.to change(BlogPost, :count).to(0)
        end # it
      end # describe
    end # context
  end # describe

  describe 'validation' do
    it { expect(instance).to be_valid }

    describe 'title must be present' do
      let(:attributes) { super().merge :title => nil }

      it { expect(instance).to have_errors.on(:title).with_message('can\'t be blank') }
    end # describe
  end # describe
end # describe
