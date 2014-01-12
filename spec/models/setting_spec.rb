# spec/models/setting_spec.rb

require 'spec_helper'

RSpec.describe Setting do
  let(:attributes) { {} }
  let(:instance) { FactoryGirl.build :setting, attributes }

  before(:each) { Setting.instance_variable_set :@cached_values, nil }

  describe '::BOOLEAN_TRUE_STRINGS' do
    it { expect(described_class::BOOLEAN_TRUE_STRINGS).to be_a Array }

    %w(true 1).each do |string|
      it { expect(described_class::BOOLEAN_TRUE_STRINGS).to include string }
    end # each
  end # describe

  describe '::TYPES' do
    it { expect(described_class::TYPES).to be_a Array }

    %w(Boolean String).each do |type|
      it { expect(described_class::TYPES).to include type }
    end # each
  end # describe

  describe '::fetch' do
    let(:name) { 'More Magic' }

    it { expect(described_class).to respond_to(:fetch).with(1..2).arguments }

    describe 'with no matching setting' do
      it 'returns nil' do
        expect(described_class.fetch name).to be nil
      end # it

      describe 'with a default value' do
        let(:default) { false }

        it 'returns the default' do
          expect(described_class.fetch name, default).to be default
        end # it
      end # describe
    end # describe

    describe 'with a matching setting' do
      let(:value) { true }
      let(:attributes) { super().merge :name => name, :type => 'Boolean', :value => value }

      before(:each) { instance.save! }

      it 'returns the value' do
        expect(described_class.fetch name).to be value
      end # it

      describe 'with a default value' do
        let(:default) { false }

        it 'returns the value' do
          expect(described_class.fetch name, default).to be value
        end # it
      end # describe
    end # describe

    describe 'with a cached value' do
      let(:value) { true }

      before(:each) do
        Setting.instance_variable_set :@cached_values, {
          name => value
        } # end hash
      end # before each

      it 'returns the value' do
        expect(described_class.fetch name).to be value
      end # it

      describe 'with a default value' do
        let(:default) { false }

        it 'returns the value' do
          expect(described_class.fetch name, default).to be value
        end # it
      end # describe
    end # describe
  end # describe

  describe '::store' do
    let(:name)  { 'More Magic' }
    let(:value) { true }

    it { expect(described_class).to respond_to(:store).with(2).arguments }

    it 'stores the value in the cache' do
      expect {
        described_class.store name, value
      }.to change {
        described_class.fetch name
      }.to(value)
    end # it
  end # describe

  describe '#save' do
    let(:name)  { 'More Magic' }
    let(:value) { true }
    let(:attributes) { super().merge :name => name, :type => 'Boolean', :value => value }
    let(:cache) { described_class.instance_variable_get :@cached_values }

    before(:each) do
      instance.save!
    end # before each

    it 'stores the value in the cache' do
      expect(cache[name]).to be == value
    end # it
  end # describe

  describe '#cast_value' do
    it { expect(instance).to respond_to(:cast_value).with(1).arguments }

    describe 'with type=String' do
      let(:attributes) { { :type => 'String' } }

      describe 'with nil' do
        let(:value) { nil }

        it 'returns nil' do
          expect(instance.cast_value value).to be nil
        end # it
      end # describe

      describe 'with a symbol' do
        let(:value) { :klaatu_verata_necktie? }

        it 'returns a string of the symbol' do
          expect(instance.cast_value value).to be == value.to_s
        end # describe
      end # describe

      describe 'with a string' do
        let(:value) { 'Greetings, programs!' }

        it 'returns the string' do
          expect(instance.cast_value value).to be == value
        end # it
      end # describe
    end # describe

    describe 'with type=Boolean' do
      let(:attributes) { { :type => 'Boolean' } }

      describe 'with nil' do
        let(:value) { nil }

        it 'returns nil' do
          expect(instance.cast_value value).to be nil
        end # it
      end # describe

      describe 'with false' do
        let(:value) { false }

        it 'returns false' do
          expect(instance.cast_value value).to be false
        end # it
      end # describe

      describe 'with true' do
        let(:value) { true }

        it 'returns true' do
          expect(instance.cast_value value).to be true
        end # it
      end # describe

      describe 'with 0' do
        let(:value) { 0 }

        it 'returns false' do
          expect(instance.cast_value value).to be false
        end # it
      end # describe

      describe 'with 1' do
        let(:value) { 1 }

        it 'returns true' do
          expect(instance.cast_value value).to be true
        end # it
      end # describe

      describe 'with "false"' do
        let(:value) { 'false' }

        it 'returns false' do
          expect(instance.cast_value value).to be false
        end # it
      end # describe

      describe 'with "true"' do
        let(:value) { 'true' }

        it 'returns true' do
          expect(instance.cast_value value).to be true
        end # it
      end # describe

      describe 'with "1"' do
        let(:value) { '1' }

        it 'returns true' do
          expect(instance.cast_value value).to be true
        end # it
      end # describe
    end # describe
  end # describe

  describe '#name' do
    it { expect(instance).to have_property :name }
  end # describe

  describe '#type' do
    it { expect(instance).to have_property :type }
  end # describe

  describe '#value' do
    it { expect(instance).to have_property :value }
  end # describe

  describe 'validation' do
    it { expect(instance).to be_valid }

    describe 'name must be present' do
      let(:attributes) { super().merge :name => nil }

      it { expect(instance).to have_errors.on(:name).with_message('can\'t be blank') }
    end # describe

    describe 'name must be unique' do
      let(:name) { 'More Magic' }
      let(:attributes) { super().merge :name => name }

      before(:each) { FactoryGirl.create :setting, :name => name }

      it { expect(instance).to have_errors.on(:name).with_message('is already taken') }
    end # describe

    describe 'type must be present' do
      let(:attributes) { super().merge :type => nil }

      it { expect(instance).to have_errors.on(:type).with_message('can\'t be blank') }
    end # describe

    describe 'type must be in Setting::TYPES' do
      let(:type) { 'Invalid' }
      let(:attributes) { super().merge :type => type }

      it { expect(instance).to have_errors.on(:type).with_message('is not included in the list') }
    end # describe
  end # describe
end # describe
