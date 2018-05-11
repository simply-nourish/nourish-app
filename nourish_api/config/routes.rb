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
  # allow GET /ingredients as well
  resources :ingredients, only: [:index, :show, :update, :destroy]

  # set up dietary_restrictions routes
  resources :dietary_restrictions

  # set up users / recipes
  # (1 user : m recipes)
  resources :users do
    resources :recipes, only: [:index, :create]
  end
  # allow GET /recipes as well
  resources :recipes, only: [:index, :show, :update, :destroy]


  
end

