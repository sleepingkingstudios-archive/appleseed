Appleseed::Application.routes.draw do
  scope '/admin' do
    devise_for :users
  end # scope

  root 'root#home'
end # routes
