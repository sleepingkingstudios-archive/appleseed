Appleseed::Application.routes.draw do
  scope '/admin' do
    devise_for :users, :controllers => { :registrations => 'admin/users/registrations' }
  end # scope

  namespace :admin do
    resource :blog do
      resources :posts, :controller => 'blog_posts' do
        collection do
          get  :import
          post :import
          post :preview
        end # collection

        member do
          get   :preview
          patch :publish
        end # member
      end # resources
    end # resource

    resource :settings, :only => %i(show update)
  end # namespace

  # Static page routes for admin namespace.
  get '/admin', :to => 'admin/pages#index', :as => :admin

  resource :blog, :only => %i(show) do
    resources :posts, :controller => 'blog_posts', :only => %i(show)
  end # resource

  # Static page routes.
  get '/about', :to => 'pages#about', :as => :about
  get '/about/fonts/freeware-license', :to => 'pages#about_fonts_freeware_license'

  root 'pages#index'
end # routes
