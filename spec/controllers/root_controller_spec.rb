# spec/controllers/root_controller_spec.rb

require 'spec_helper'

RSpec.describe RootController do
  describe "GET /" do
    def perform_request
      get :home
    end # method perform_request

    it 'responds with 200 ok' do
      perform_request
      expect(response.status).to be == 200
    end # it

    it 'renders the home template' do
      perform_request
      expect(response).to render_template 'home'
    end # it
  end # describe
end # describe
