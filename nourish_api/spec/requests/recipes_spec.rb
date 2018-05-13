# recipes request spec
# /spec/requests/recipes_spec.rb
# test methods adapted from https://scotch.io/tutorials/build-a-restful-json-api-with-rails-5-part-one

require 'rails_helper'
require 'support/request_spec_helper'
require 'json'

RSpec.describe 'Recipes API', type: :request do

  let(:num_recipes) { 5 }
  let(:num_ingredients) { 10 }
  let(:num_restrictions) { 0 }

  let!(:user_1) { create(:user) } 
  let!(:user_2) { create(:user) }

  let!(:uid_1) { user_1.id }
  let!(:uid_2) { user_2.id }

  let!(:user_1_recipes) { create_recipe_list(user_1, num_recipes, num_ingredients) }
  let!(:user_2_recipes) { create_recipe_list(user_2, num_recipes, num_ingredients) }

  let(:id) { user_1_recipes.first.id }

  #
  # spec for GET /users/:id/recipes
  #

  describe "GET /users/:id/recipes" do
    before { get "/users/#{uid_1}/recipes" }

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
          rest = rec['dietary_restrictions']
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

    before { get "/recipes/#{id}" }

    context 'when recipe exists' do

      # assuming a recipe exists with id == 1
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
      
      it 'returns the recipe' do
        expect(json['id']).to eq id
      end

    end

    context 'when recipe record does not exist' do
 
      let(:id) { -1 }
     
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
      before { post "/users/#{uid_1}/recipes", params: valid_attrs }

      it 'returns status code 201' do
        expect(response).to have_http_status 201
      end
    end

    context 'when request attributes are invalid' do
      before { post "/users/#{uid_1}/recipes", params: {} }

      it 'returns status code 400' do
        expect(response).to have_http_status 400
      end

    end
 
  end # end describe block

  #
  # spec for PUT /recipes
  #

  describe "PUT /recipes" do

    let(:valid_attrs) { { recipe: { title: 'croque monsieur' } } }
    before { put "/recipes/#{id}", params: valid_attrs }

    context 'when recipe exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status 204
      end

      it 'updates the recipe' do
        updated_recipe = Recipe.find(id)
        expect(updated_recipe.title).to match /croque monsieur/
      end
    end # end context

    context 'when recipe does not exist' do

      let(:id) { 0 }
      it 'returns status code 404' do
        expect(response).to have_http_status 404
      end

      it 'returns a not found message' do
        expect(response.body).to match /Couldn't find Recipe/
      end

    end # end context

  end # end describe block

  #
  # spec for DELETE /recipes
  #

  describe 'DELETE /recipes/:id' do

    before { delete "/recipes/#{id}"}

    it 'returns status code 204' do
      expect(response).to have_http_status 204
    end

  end # end describe block

end # end test
