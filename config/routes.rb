Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'

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

  # set up dietary_restrictions routes
  resources :measures

  # set up users + recipes, meal_plans
  # (1 user : m recipes)
  # (1 user : m meal_plans )
  resources :users, only: [:index, :show] do
    resources :recipes, only: [:index, :create]
    resources :meal_plans, only: [:index, :create]
    resources :shopping_lists, only: [:index, :create]
  end
  
  # allow GET /recipes as well
  resources :recipes, only: [:index, :update, :destroy]

  # specify exact form of GET /recipes/:id to avoid conflict with /search 
  # :id can only contain digits
  get 'recipes/:id', to: 'recipes#show', constraints: { id: /\d.+/ }

  # allow PUT / DELETE meal_plans
  resources :meal_plans, only: [:show, :update, :destroy]

  # allow PUT / DELETE shopping_lists
  resources :shopping_lists, only: [:show, :update, :destroy]

  # add recipes/search route
  resources :recipes do 
    collection do
      get 'search'
    end  
  end 

end

