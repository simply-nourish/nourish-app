Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'

  #devise_for :users
  api_version(:module => "V1", :path => {:value => "v1"}) do
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  constraints subdomain: 'api' do
  end

  # set up ingredient_categories / ingredients routes
  # (1 category : m ingredients)
  resources :ingredient_categories do
    resources :ingredients, only: [:index, :create]
  end

  resources :ingredients, only: [:show, :update, :destroy]

  # set up dietary_restrictions routes
  resources :dietary_restrictions
  
end

