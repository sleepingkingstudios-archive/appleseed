# spec/controllers/admin/settings_controller_spec.rb

require 'spec_helper'

RSpec.describe Admin::SettingsController do
  describe "GET /" do
    def perform_action
      get :show
    end # method perform_action

    it 'responds with 302 found and renders the home template' do
      perform_action
      expect(response.status).to be == 302
      expect(response).to redirect_to :root
    end # it
  end # describe
end # describe
