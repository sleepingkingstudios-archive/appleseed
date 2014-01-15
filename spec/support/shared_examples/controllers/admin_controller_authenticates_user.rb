# spec/support/shared_examples/controllers/admin_controller_authenticates_user.rb

module Appleseed
  module SharedExamples
    module AdminControllerAuthenticatesUser
      RESTFUL_ACTIONS = %w(index new create show edit update destroy)

      module Helpers
        def expect_render_for_action action, template = nil
          template ||= action
          describe action do
            let(:params) { defined?(super) ? super() : {} }

            it "responds with 200 ok and renders the #{template} template" do
              get action, params
              expect(response.status).to be == 200
              expect(response).to render_template template
            end # it
          end # describe
        end # class method authenticate_user_for_action

        def expect_redirect_for_action action, method = :get
          describe action do
            let(:params) { defined?(super) ? super() : {} }

            it 'redirects to root' do
              send method, action, params
              expect(response.status).to be == 302
              expect(response).to redirect_to :root
            end # it
          end # describe
        end # class method authenticate_user_for_action

        def filter_actions actions, options
          if !options[:only].blank?
            options[:only] = [options[:only]].flatten unless options[:only].is_a?(Array)
            actions.select { |action| options[:only].include?(action.to_s.intern) }
          elsif !options[:except].blank?
            options[:except] = [options[:except]].flatten unless options[:except].is_a?(Array)
            actions.select { |action| !options[:except].include?(action.to_s.intern) }
          else
            actions
          end # if-elsif-else
        end # class method filter_actions
      end # module

      shared_examples 'authenticates the user for action' do |controller, action, options|
        extend Appleseed::SharedExamples::AdminControllerAuthenticatesUser::Helpers

        options = {} unless options.is_a?(Hash)

        context 'with no authenticated user' do
          before(:each) { sign_out :user }

          expect_redirect_for_action action, options.fetch(:method, :get)
        end # context

        if options.fetch(:template, false) || options.fetch(:method, :get) == :get
          context 'with an authenticated user' do
            let(:user) { defined?(super) ? super() : FactoryGirl.create(:user) }

            before(:each) { sign_in user }

            expect_render_for_action action, options.fetch(:template, action)
          end # context
        end # if
      end # shared examples

      shared_examples 'authenticates the user for resources' do |controller, options|
        extend Appleseed::SharedExamples::AdminControllerAuthenticatesUser::Helpers

        options = {} unless options.is_a?(Hash)
        actions = filter_actions RESTFUL_ACTIONS, options

        let(:params)               { defined?(super) ? super() : {} }
        let(:resource_primary_key) { defined?(super) ? super() : :id }

        context 'with no authenticated user' do
          before(:each) { sign_out :user }

          expect_redirect_for_action :index         if actions.include?('index')
          expect_redirect_for_action :new           if actions.include?('new')
          expect_redirect_for_action :create, :post if actions.include?('create')

          context 'with a resource' do
            let(:params) { super().merge resource_primary_key => resource_id }

            expect_redirect_for_action :show             if actions.include?('show')
            expect_redirect_for_action :edit             if actions.include?('edit')
            expect_redirect_for_action :update, :patch   if actions.include?('update')
            expect_redirect_for_action :destroy, :delete if actions.include?('destroy')
          end # context
        end # context

        context 'with an authenticated user' do
          let(:user) { defined?(super) ? super() : FactoryGirl.create(:user) }

          before(:each) { sign_in user }

          expect_render_for_action :index if actions.include?('index')
          expect_render_for_action :new   if actions.include?('new')

          context 'with a resource' do
            let(:params) { super().merge resource_primary_key => resource_id }

            expect_render_for_action :show if actions.include?('show')
            expect_render_for_action :edit if actions.include?('edit')
          end # context
        end # context
      end # shared examples

      shared_examples 'authenticates the user for singular resource' do |controller, options|
        extend Appleseed::SharedExamples::AdminControllerAuthenticatesUser::Helpers

        options = {} unless options.is_a?(Hash)
        actions = filter_actions RESTFUL_ACTIONS, options

        let(:params) { defined?(super) ? super() : {} }

        context 'with no authenticated user' do
          before(:each) { sign_out :user }

          expect_redirect_for_action :new              if actions.include?('new')
          expect_redirect_for_action :create, :post    if actions.include?('create')
          expect_redirect_for_action :show             if actions.include?('show')
          expect_redirect_for_action :edit             if actions.include?('edit')
          expect_redirect_for_action :update, :patch   if actions.include?('update')
          expect_redirect_for_action :destroy, :delete if actions.include?('destroy')
        end # context

        context 'with an authenticated user' do
          let(:user) { defined?(super) ? super() : FactoryGirl.create(:user) }

          before(:each) { sign_in user }

          expect_render_for_action :show  if actions.include?('show')
          expect_render_for_action :new   if actions.include?('new')
          expect_render_for_action :edit  if actions.include?('edit')
        end # context
      end # shared examples
    end # module
  end # module
end # module
