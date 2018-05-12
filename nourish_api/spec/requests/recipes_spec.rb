# recipes request spec
# /spec/requests/recipes_spec.rb
# test methods adapted from https://scotch.io/tutorials/build-a-restful-json-api-with-rails-5-part-one

require 'rails_helper'
require 'support/request_spec_helper'

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

  describe "GET/recipes/:id" do

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

  describe "POST /users/:id/recipes" do
    let(:valid_params) { { recipe: { title: 'New Recipe', 
                             summary: 'A new recipe for you, just you.', 
                             instructions: 'turn left on I-95, second gas station on the left',
                            #   dietary_restrictions: [dietary_restriction_id: 1],
                             ingredient_recipes_attributes: [ 
                                                            { ingredient_id: 1, measure_id: 1, amount: 1 }, 
                                                            { ingredient_id: 2, measure_id: 2, amount: 2 } 
                                                          ]
                             } 
                       } }         

    context 'when request is valid' do
      before { post "/users/#{uid_1}/recipes", params: valid_params }
        
        it 'creates a recipe' do
          expect(response).to have_http_status 200
          #    expect( json['recipe'].title).to eq 'New Recipe'
        end

      end


  end # end describe block


  describe "PUT/recipes/" do



  end # end describe block


  describe "DELETE/recipes/" do



  end # end describe block

end # end test

