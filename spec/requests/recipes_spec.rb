# recipes request spec
# /spec/requests/recipes_spec.rb
# test methods adapted from https://scotch.io/tutorials/build-a-restful-json-api-with-rails-5-part-one

require 'rails_helper'
require 'support/request_spec_helper'
require 'json'

RSpec.describe 'Recipes API', type: :request do

  let(:num_recipes) { 5 }
  let(:num_ingredients) { 10 }
  let(:num_restrictions) { 2 }

  let!(:user_1) { create(:user) } 
  subject { auth_post user_1, '/auth', params: {  email: user_1.email,
                                                  password: user_1.password,
                                                  password_confirmation: user_1.password, 
                                                  confirm_success_url: "www.google.com" } }

  let!(:user_2) { create(:user) }

  let!(:uid_1) { user_1.id }
  let!(:uid_2) { user_2.id }

  let!(:user_1_recipes) { create_recipe_list(user_1, num_recipes, num_ingredients, num_restrictions ) }
  let!(:user_2_recipes) { create_recipe_list(user_2, num_recipes, num_ingredients, 0 ) }

  let(:user_2_first_title) { user_2_recipes.first.title }

  let(:user_1_first_rec_id) { user_1_recipes.first.id }

  #
  # spec for GET /users/:id/recipes
  #

  describe "GET /users/:id/recipes" do
    before { auth_get user_1, "/users/#{user_1.id}/recipes", params: {} }
  #  before { get "/users/#{uid_1}/recipes", headers: user_1.headers }

    context 'when recipes are in database' do
    
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all of that user\'s recipes' do
        expect(json.size).to eq user_1_recipes.size      
      end

      it 'returns all ingredients in that recipe' do
        json.each do |rec|
          ingredients = rec['ingredient_recipes']
          expect(ingredients.size).to eq num_ingredients
        end
      end

      it 'returns appropriate dietary restrictions' do
        json.each do |rec|
          rest = rec['dietary_restriction_recipes']
          expect(rest.size).to eq num_restrictions
        end
      end

    end # end context

  end # end describe

  #
  # spec for GET /recipes
  #

  describe "GET /recipes" do
    before { get "/recipes" } 

    context 'when recipes are in database' do
  
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all recipes' do
        expect(json.size).to eq user_1_recipes.size + user_2_recipes.size
      end

    end

  end
  
  #
  # spec for GET /recipes/:id
  #

  describe "GET /recipes/:id" do

    before { get "/recipes/#{user_1_first_rec_id}" }

    context 'when recipe exists' do

      # assuming a recipe exists with id == 1
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
      
      it 'returns the recipe' do
        expect(json['id']).to eq user_1_first_rec_id
      end

    end

    context 'when recipe record does not exist' do
 
      let(:user_1_first_rec_id) { -1 }
     
      it 'returns status code 404' do
        expect(response).to have_http_status 404
      end

      it 'returns not found message' do
        expect(response.body).to match /Couldn't find Recipe/
      end  

    end # end context
      
  end # end describe block

  #
  # spec for POST /users/:id/recipes
  #

  describe 'POST /users/:id/recipes' do
  
    # creating some test data...building known good data 

    let!(:ingredient_category) { create(:ingredient_category) }
    let!(:ingredient) { create(:ingredient, ingredient_category_id: ingredient_category.id) }
    let(:iid) { ingredient.id }

    let!(:measure) { create(:measure) }
    let!(:mid) { measure.id }

    # use that data to build our recipe request

    let(:valid_attrs) { { :recipe => {
                           title: 'myrecipe', summary: 'it\'s a new one', 
                           instructions: 'do a thing', 
                           ingredient_recipes_attributes: [
                                { ingredient_id: "#{iid}", measure_id: "#{mid}", amount: '3' } ] 
                           } 
                        } 
                      }
     
    context 'when request attributes are valid' do
      before { auth_post user_1, "/users/#{user_1.id}/recipes", params: valid_attrs }

      it 'returns status code 201' do
        expect(response).to have_http_status 201
      end
    end

    context 'when request attributes are invalid' do
      before { auth_post user_1, "/users/#{user_1.id}/recipes", params: {} }

      it 'returns status code 400' do
        expect(response).to have_http_status 400
      end
    end

    context 'when user is not authorized to POST' do
      before { auth_post user_1, "/users/#{user_2.id}/recipes", params: {} }

      it 'returns unauthorized' do
        expect(response).to have_http_status 401
      end
    end 
 
  end # end describe block

  #
  # spec for PUT /recipes
  #

  describe "PUT /recipes" do

    let(:valid_attrs) { { recipe: { title: 'croque monsieur' } } }
    before { auth_put user_1, "/recipes/#{user_1_first_rec_id}", params: valid_attrs }

    context 'when recipe exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status 204
      end

      it 'updates the recipe' do
        updated_recipe = Recipe.find(user_1_first_rec_id)
        expect(updated_recipe.title).to match /croque monsieur/
      end
    end # end context

    context 'when recipe does not exist' do

      let(:user_1_first_rec_id) { -1 }
      it 'returns status code 404' do
        expect(response).to have_http_status 404
      end

      it 'returns a not found message' do
        expect(response.body).to match /Couldn't find Recipe/
      end

    end # end context

    context 'when user not authorized to PUT' do
      before { auth_put user_1, "/recipes/#{user_2.recipes.first.id}", params: valid_attrs }
      let!(:prevname) { user_2_first_title }

      it 'returns unauthorized' do
        expect(response).to have_http_status 401
      end

      it 'has not modified the name' do
        expect(user_2.recipes.first.title).to eq prevname
      end

    end # end ontext 

  end # end describe block

  #
  # spec for DELETE /recipes
  #

  describe 'DELETE /recipes/:id' do

    context 'when authorized user attempts to delete' do

      before { auth_delete user_1, "/recipes/#{user_1.recipes.first.id}", params: {} }
  
      it 'returns status code 204' do
        expect(response).to have_http_status 204
      end

    end

    context 'when unauthorized user attempts to delete' do
      
      before { auth_delete user_1, "/recipes/#{user_2.recipes.first.id}", params: {} }

      it 'returns unauthorized' do
        expect(response).to have_http_status 401
      end 

    end

  end # end describe block

end # end test
