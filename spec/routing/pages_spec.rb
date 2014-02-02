# spec/routing/pages_spec.rb

require 'spec_helper'

RSpec.describe 'routes for static pages' do
  let(:controller) { 'pages' }

  describe 'GET /' do
    let(:action) { 'index' }
    let(:path)   { '/' }

    it 'routes to index' do
      expect(get path).to route_to({
        :controller => controller,
        :action     => action
      }) # end expect
    end # it

    describe 'root_path' do
      let(:path) { root_path }

      it 'routes to index' do
        expect(get path).to route_to({
          :controller => controller,
          :action     => action
        }) # end expect
      end # it
    end # describe
  end # describe

  describe 'GET /about' do
    let(:action) { 'about' }
    let(:path)   { '/about' }

    it 'routes to about' do
      expect(get path).to route_to({
        :controller => controller,
        :action     => action
      }) # end expect
    end # it

    describe 'about_path' do
      let(:path) { about_path }

      it 'routes to about' do
        expect(get path).to route_to({
          :controller => controller,
          :action     => action
        }) # end expect
      end # it
    end # describe
  end # describe
end # describe
