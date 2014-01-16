Appleseed::Application.routes.draw do
  scope '/admin' do
    devise_for :users, :controllers => { :registrations => 'admin/users/registrations' }
  end # scope

  namespace :admin do
    resource :blog do
      resources :blog_posts, :as => :posts, :only => %i(index create new show edit update)
    end # resource

    resource :settings, :only => %i(show update)
  end # namespace

  get :admin, :to => 'admin/pages#index', :as => :admin

  resource :blog, :only => %i(show)

  root 'pages#index'
end # routes
