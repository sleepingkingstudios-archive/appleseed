Appleseed::Application.routes.draw do
  scope '/admin' do
    devise_for :users, :controllers => { :registrations => 'admin/users/registrations' }
  end # scope

  namespace :admin do
    resource :settings, :only => %i(show update)
  end # namespace

  root 'root#home'
end # routes
