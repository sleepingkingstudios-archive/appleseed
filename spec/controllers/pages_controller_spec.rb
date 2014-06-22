# spec/controllers/pages_controller_spec.rb

require 'spec_helper'

RSpec.describe PagesController do
  describe '#index' do
    it 'responds with 200 ok and renders the home template' do
      get :index
      expect(response.status).to be == 200
      expect(response).to render_template 'index'
    end # it
  end # describe

  describe '#about' do
    it 'responds with 200 ok and renders the about template' do
      get :about
      expect(response.status).to be == 200
      expect(response).to render_template 'about'
    end # it
  end # describe

  describe '#projects' do
    it 'responds with 200 ok and renders the projects template' do
      get :projects
      expect(response.status).to be == 200
      expect(response).to render_template 'projects'
    end # it
  end # it
end # describe
