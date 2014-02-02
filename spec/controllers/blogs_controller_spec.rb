# spec/controllers/blogs_controller_spec.rb

require 'spec_helper'

RSpec.describe BlogsController do
  describe 'show' do
    def perform_request
      get :show
    end # method perform_request

    context 'with no blog created' do
      it 'redirects to root' do
        perform_request
        expect(response.status).to be == 302
        expect(response).to redirect_to :root
      end # it
    end # context

    context 'with a blog created' do
      before(:each) { FactoryGirl.create :blog }

      it 'responds with 200 ok and renders the show template' do
        perform_request
        expect(response.status).to be == 200
        expect(response).to render_template 'show'
      end # it
    end # context
  end # describe
end # describe
