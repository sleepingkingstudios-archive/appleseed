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

  describe '#to_builder' do
    it { expect(instance).to respond_to(:to_builder).with(0).arguments }
    it { expect(instance.to_builder).to be_a Jbuilder }
    it 'generates parsable JSON' do
      expect { JSON.parse instance.to_builder.target! }.not_to raise_error
    end # it

    context 'with generated JSON' do
      let(:json) { instance.to_builder.target! }
      let(:hsh)  { JSON.parse json }

      it { expect(hsh['email']).to be == instance.email }
    end # context
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
