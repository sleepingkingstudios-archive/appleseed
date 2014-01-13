# spec/controllers/admin/settings_controller_spec.rb

require 'spec_helper'

RSpec.describe Admin::SettingsController do
  describe "GET /" do
    before(:each) { get :show }

    it 'responds with 302 found' do
      expect(response.status).to be == 302
    end # it

    it 'renders the home template' do
      expect(response).to redirect_to :root
    end # it
  end # describe
end # describe
