# spec/support/shared_examples/controllers/admin_controller_authenticates_user.rb

module Appleseed
  module SharedExamples
    module AdminControllerAuthenticatesUser
      RESTFUL_ACTIONS = %w(index new create show edit update destroy)

      shared_examples 'authenticates the user' do |controller, options|
        def self.authenticate_user_for_action action, method = :get
          describe action do
            it 'redirects to root' do
              send method, action
              expect(response.status).to be == 302
              expect(response).to redirect_to :root
            end # it
          end # describe
        end # class method authenticate_user_for_action

        if options && options[:only].is_a?(Array)
          actions = options[:only].map(&:to_s)
        elsif options && options[:except].is_a?(Array)
          actions = RESTFUL_ACTIONS - options[:except].map(&:to_s)
        else
          actions = RESTFUL_ACTIONS
        end # if-elsif-else

        # Ensure no user is signed in during the examples.
        before(:each) { sign_out :user }

        authenticate_user_for_action :index            if actions.include?('index')
        authenticate_user_for_action :new              if actions.include?('new')
        authenticate_user_for_action :create, :post    if actions.include?('create')
        authenticate_user_for_action :show             if actions.include?('show')
        authenticate_user_for_action :edit             if actions.include?('edit')
        authenticate_user_for_action :update, :patch   if actions.include?('update')
        authenticate_user_for_action :destroy, :delete if actions.include?('destroy')
      end # shared examples
    end # module
  end # module
end # module
