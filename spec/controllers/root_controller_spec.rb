# spec/controllers/root_controller_spec.rb

require 'spec_helper'

RSpec.describe RootController do
  describe "GET /" do
    before(:each) { get :home }

    it 'responds with 200 ok' do
      expect(response.status).to be == 200
    end # it

    it 'renders the home template' do
      expect(response).to render_template 'home'
    end # it
  end # describe
end # describe
