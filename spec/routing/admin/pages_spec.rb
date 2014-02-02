# spec/routing/admin/pages_spec.rb

require 'spec_helper'

RSpec.describe 'routes for admin static pages' do
  let(:controller) { 'admin/pages' }

  describe 'GET /' do
    let(:action) { 'index' }
    let(:path)   { '/admin' }

    it 'routes to index' do
      expect(get path).to route_to({
        :controller => controller,
        :action     => action
      }) # end expect
    end # it

    describe 'admin_path' do
      let(:path) { admin_path }

      it 'routes to index' do
        expect(get path).to route_to({
          :controller => controller,
          :action     => action
        }) # end expect
      end # it
    end # describe
  end # describe
end # describe