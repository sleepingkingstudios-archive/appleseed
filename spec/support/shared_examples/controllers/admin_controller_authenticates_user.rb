# spec/support/shared_examples/controllers/admin_controller_authenticates_user.rb

module Appleseed
  module SharedExamples
    module AdminControllerAuthenticatesUser
      RESTFUL_ACTIONS = %w(index new create show edit update destroy)

      shared_examples 'authenticates the user' do |controller, options|
        if options && options[:only].is_a?(Array)
          actions = options[:only].map(&:to_s)
        elsif options && options[:except].is_a?(Array)
          actions = RESTFUL_ACTIONS - options[:except].map(&:to_s)
        else
          actions = RESTFUL_ACTIONS
        end # if-elsif-else

        context 'with no authenticated user' do
          def self.expect_redirect_for_action action, method = :get
            describe action do
              it 'redirects to root' do
                send method, action
                expect(response.status).to be == 302
                expect(response).to redirect_to :root
              end # it
            end # describe
          end # class method authenticate_user_for_action

          before(:each) { sign_out :user }

          expect_redirect_for_action :index            if actions.include?('index')
          expect_redirect_for_action :new              if actions.include?('new')
          expect_redirect_for_action :create, :post    if actions.include?('create')
          expect_redirect_for_action :show             if actions.include?('show')
          expect_redirect_for_action :edit             if actions.include?('edit')
          expect_redirect_for_action :update, :patch   if actions.include?('update')
          expect_redirect_for_action :destroy, :delete if actions.include?('destroy')
        end # context

        context 'with an authenticated user' do
          def self.expect_render_for_action action
            describe action do
              it 'redirects to root' do
                get action
                expect(response.status).to be == 200
                expect(response).to render_template action
              end # it
            end # describe
          end # class method authenticate_user_for_action

          let(:user) { defined?(super) ? super() : FactoryGirl.create(:user) }

          before(:each) { sign_in user }

          expect_render_for_action :index if actions.include?('index')
          expect_render_for_action :show  if actions.include?('show')
          expect_render_for_action :new   if actions.include?('new')
          expect_render_for_action :edit  if actions.include?('edit')
        end # context
      end # shared examples
    end # module
  end # module
end # module
