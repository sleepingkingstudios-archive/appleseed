# spec/controllers/admin/users/registrations_controller_spec.rb

require 'spec_helper'

RSpec.describe Admin::Users::RegistrationsController do
  before(:each) do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end # before each

  describe "GET /admin/users/sign_up" do
    def perform_request
      get :new
    end # method perform_request

    context 'with :allow_user_registration? => true' do
      before(:each) do
        allow(Setting).to receive(:fetch).and_return(true)
      end # before each

      it 'responds with 200 ok' do
        perform_request
        expect(response.status).to be == 200
      end # it

      it 'renders the new template' do
        perform_request
        expect(response).to render_template 'devise/registrations/new'
      end # it
    end # context

    context 'with :allow_user_registration? => false' do
      before(:each) do
        allow(Setting).to receive(:fetch).and_return(false)
      end # before each

      context 'and no registered users' do
        it 'responds with 200 ok' do
          perform_request
          expect(response.status).to be == 200
        end # it

        it 'renders the new template' do
          perform_request
          expect(response).to render_template 'devise/registrations/new'
        end # it
      end # context

      context 'with one registered user' do
        before(:each) { FactoryGirl.create :user }

        it 'responds with 302 redirect' do
          perform_request
          expect(response.status).to be == 302
        end # it

        it 'redirects to :root' do
          perform_request
          expect(response).to redirect_to :root
        end # it
      end # context
    end # context
  end # describe

  describe "POST /admin/users" do
    let(:data) { {} }

    def perform_request
      post :create, data
    end # method perform_request

    context 'with :allow_user_registration? => true' do
      before(:each) do
        allow(Setting).to receive(:fetch).and_return(true)
      end # before each

      context 'with an invalid user' do
        it 'responds with 200 ok' do
          perform_request
          expect(response.status).to be == 200
        end # it

        it 'renders the new template' do
          perform_request
          expect(response).to render_template 'devise/registrations/new'
        end # it
      end # context

      context 'with a valid user' do
        let(:data) { { :user => FactoryGirl.attributes_for(:user) } }

        it 'responds with 302 redirect' do
          perform_request
          expect(response.status).to be == 302
        end # it

        it 'redirects to :root' do
          perform_request
          expect(response).to redirect_to :root
        end # it
      end # context
    end # context

    context 'with :allow_user_registration? => false' do
      before(:each) do
        allow(Setting).to receive(:fetch).and_return(false)
      end # before each

      context 'and no registered users' do
        context 'with an invalid user' do
          it 'responds with 200 ok' do
            perform_request
            expect(response.status).to be == 200
          end # it

          it 'renders the new template' do
            perform_request
            expect(response).to render_template 'devise/registrations/new'
          end # it
        end # context

        context 'with a valid user' do
          let(:data) { { :user => FactoryGirl.attributes_for(:user) } }

          it 'responds with 302 redirect' do
            perform_request
            expect(response.status).to be == 302
          end # it

          it 'redirects to :root' do
            perform_request
            expect(response).to redirect_to :root
          end # it
        end # context
      end # context

      context 'with one registered user' do
        before(:each) { FactoryGirl.create :user }

        it 'responds with 302 redirect' do
          perform_request
          expect(response.status).to be == 302
        end # it

        it 'redirects to :root' do
          perform_request
          expect(response).to redirect_to :root
        end # it
      end # context
    end # context
  end # describe
end # describe
