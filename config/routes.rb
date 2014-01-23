Appleseed::Application.routes.draw do
  scope '/admin' do
    devise_for :users, :controllers => { :registrations => 'admin/users/registrations' }
  end # scope

  namespace :admin do
    resource :blog do
      resources :posts, :controller => 'blog_posts' do
        member do
          patch :publish
        end # member
      end # resources
    end # resource

    resource :settings, :only => %i(show update)
  end # namespace

  get :admin, :to => 'admin/pages#index', :as => :admin

  resource :blog, :only => %i(show) do
    resources :posts, :controller => 'blog_posts', :only => %i(show)
  end # resource

  root 'pages#index'
end # routes
