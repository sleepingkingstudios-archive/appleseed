# spec/controllers/admin/settings_controller_spec.rb

require 'spec_helper'

RSpec.describe Admin::SettingsController do
  include Appleseed::SharedExamples::AdminControllerAuthenticatesUser

  expect_behavior 'authenticates the user for singular resource', described_class, :only => %i(show update)

  context 'with an authenticated user' do
    let(:user) { FactoryGirl.create :user }

    before(:each) { sign_in user }

    describe 'PATCH /admin/settings' do
      let(:attributes) { {} }

      def perform_action
        patch :update, attributes
      end # method perform_action

      context 'with no settings defined' do
        it 'responds with 200 ok and renders the show template' do
          perform_action
          expect(response.status).to be == 200
          expect(response).to render_template 'show'
        end # it
      end # context
    end # describe
  end # describe
end # describe
