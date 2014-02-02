# spec/support/shared_examples/routing/routes_to_resource.rb

require Rails.root.join('spec/support/shared_examples/action_helpers')

module Appleseed
  module SharedExamples
    module RoutesToResource
      module Helpers
        include Appleseed::SharedExamples::ActionHelpers

        def expect_not_to_be_routable controller, local_path, method
          describe local_path do
            let(:resource_id) { defined?(super) ? super() : '' }
            let(:path) do
              "#{controller_path}/#{local_path.gsub(/:id/, resource_id)}"
            end # let

            it 'is not routable' do
              expect(send method, path).not_to be_routable
            end # it
          end # describe
        end # class method expect_not_to_be_routable

        def expect_to_route controller, local_path, method, action
          describe local_path do
            let(:resource_id) { defined?(super) ? super() : '' }
            let(:path) do
              "#{controller_path}/#{local_path.gsub(/:id/, resource_id)}"
            end # let
            let(:routing) do
              params.merge :controller => controller, :action => action
            end # let

            it "routes to #{action}" do
              expect(send method, path).to route_to routing
            end # it
          end # describe
        end # class method expect_to_route
      end # module

      shared_examples 'routes to resources' do |controller, options|
        extend Appleseed::SharedExamples::RoutesToResource::Helpers

        options = {} unless options.is_a?(Hash)
        actions = filter_actions Appleseed::SharedExamples::ActionHelpers::RESTFUL_ACTIONS, options

        let(:controller_path)      { defined?(super) ? super() : controller }
        let(:params)               { defined?(super) ? super() : {} }
        let(:resource_primary_key) { defined?(super) ? super() : :id }
        let(:resource_id)          { defined?(super) ? super() : '42' }

        expect_to_route controller, '',    :get,  'index'  if actions.include?('index')
        expect_to_route controller, '',    :post, 'create' if actions.include?('create')
        expect_to_route controller, 'new', :get,  'new'    if actions.include?('new')

        context 'with a resource' do
          let(:params) { super().merge resource_primary_key => resource_id }

          expect_to_route controller, ':id',      :get,    'show'    if actions.include?('show')
          expect_to_route controller, ':id',      :patch,  'update'  if actions.include?('update')
          expect_to_route controller, ':id',      :delete, 'destroy' if actions.include?('destroy')
          expect_to_route controller, ':id/edit', :get,    'edit'    if actions.include?('edit')
        end # context
      end # shared examples

      shared_examples 'routes to singular resource' do |controller, options|
        extend Appleseed::SharedExamples::RoutesToResource::Helpers

        options = {} unless options.is_a?(Hash)
        actions = filter_actions Appleseed::SharedExamples::ActionHelpers::RESTFUL_ACTIONS, options

        let(:controller_path)      { defined?(super) ? super() : controller.singularize }
        let(:params)               { defined?(super) ? super() : {} }

        expect_to_route controller, '',     :get,    'show'    if actions.include?('show')
        expect_to_route controller, '',     :post,   'create'  if actions.include?('create')
        expect_to_route controller, '',     :patch,  'update'  if actions.include?('update')
        expect_to_route controller, '',     :delete, 'destroy' if actions.include?('destroy')
        expect_to_route controller, 'new',  :get,    'new'     if actions.include?('new')
        expect_to_route controller, 'edit', :get,    'edit'    if actions.include?('edit')
      end # shared examples

      shared_examples 'does not route to resources' do |controller, options|
        extend Appleseed::SharedExamples::RoutesToResource::Helpers

        options = {} unless options.is_a?(Hash)
        actions = filter_actions Appleseed::SharedExamples::ActionHelpers::RESTFUL_ACTIONS, options

        let(:controller_path)      { defined?(super) ? super() : controller }
        let(:params)               { defined?(super) ? super() : {} }
        let(:resource_primary_key) { defined?(super) ? super() : :id }
        let(:resource_id)          { defined?(super) ? super() : '42' }

        # Note: with #show but not #new defined, /resource/new will route to
        # the #show action with an id of "new", so we need to ensure that #show
        # is not routable before we can verify #new.

        expect_not_to_be_routable controller, '',    :get  if actions.include?('index')
        expect_not_to_be_routable controller, '',    :post if actions.include?('create')
        expect_not_to_be_routable controller, 'new', :get  if actions.include?('new') && actions.include?('show')

        context 'with a resource' do
          let(:params) { super().merge resource_primary_key => resource_id }

          expect_not_to_be_routable controller, ':id',      :get    if actions.include?('show')
          expect_not_to_be_routable controller, ':id',      :patch  if actions.include?('update')
          expect_not_to_be_routable controller, ':id',      :delete if actions.include?('destroy')
          expect_not_to_be_routable controller, ':id/edit', :get    if actions.include?('edit')
        end # context
      end # shared examples

      shared_examples 'does not route to singular resource' do |controller, options|
        extend Appleseed::SharedExamples::RoutesToResource::Helpers

        options = {} unless options.is_a?(Hash)
        actions = filter_actions Appleseed::SharedExamples::ActionHelpers::RESTFUL_ACTIONS, options

        let(:controller_path)      { defined?(super) ? super() : controller }
        let(:params)               { defined?(super) ? super() : {} }

        expect_not_to_be_routable controller, '',     :get    if actions.include?('show')
        expect_not_to_be_routable controller, '',     :post   if actions.include?('create')
        expect_not_to_be_routable controller, '',     :patch  if actions.include?('update')
        expect_not_to_be_routable controller, '',     :delete if actions.include?('destroy')
        expect_not_to_be_routable controller, 'new',  :get    if actions.include?('new')  && actions.include?('show')
        expect_not_to_be_routable controller, 'edit', :get    if actions.include?('edit') && actions.include?('show')
      end # shared examples
    end # module
  end # module
end # module
