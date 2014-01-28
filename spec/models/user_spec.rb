# spec/models/user_spec.rb

require 'spec_helper'

RSpec.describe User do
  let(:attributes) { {} }
  let(:instance) { FactoryGirl.build :user, attributes }

  describe '#posts' do
    it { expect(instance).to respond_to(:posts).with(0).arguments }
    it { expect(instance.posts).to be_a Array }
  end # describe

  describe '#email' do
    it { expect(instance).to have_property(:email) }
  end # describe

  describe 'validation' do
    it { expect(instance).to be_valid }

    describe 'email must be present' do
      let(:attributes) { super().merge :email => nil }

      it { expect(instance).to have_errors.on(:email).with_message('can\'t be blank') }
    end # describe

    describe 'email must be unique' do
      let(:email) { 'legion@ssv.normandy' }
      let(:attributes) { super().merge :email => email }

      before(:each) { FactoryGirl.create :user, :email => email }

      it { expect(instance).to have_errors.on(:email).with_message('is already taken') }
    end # describe
  end # describe
end # describe
