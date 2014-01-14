Appleseed::Application.routes.draw do
  scope '/admin' do
    devise_for :users, :controllers => { :registrations => 'admin/users/registrations' }
  end # scope

  namespace :admin do
    resource :blog

    resource :settings, :only => %i(show update)
  end # namespace

  resource :blog, :only => %i(show)

  root 'root#home'
end # routes
