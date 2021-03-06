# ingredient request spec
# /spec/requests/ingredients_spec.rb
# test methods adapted from https://scotch.io/tutorials/build-a-restful-json-api-with-rails-5-part-one

require 'rails_helper'

RSpec.describe 'Ingredient API', type: :request do
  let!(:ingredient_category) { create(:ingredient_category) }
  let!(:ingredients) { create_list(:ingredient, 10, ingredient_category_id: ingredient_category.id) }
  let(:ingredient_category_id) { ingredient_category.id }
  let(:ingredient_category_name) { ingredient_category.name }
  let(:id) { ingredients.first.id }

  describe 'GET /ingredients' do

    before { get "/ingredients" }
    
    context 'when ingredients are in database' do
      it 'returns status code 200' do
        expect(response).to have_http_status 200
      end
   
      it 'returns all ingredients' do
        expect(json.size).to eq 10
      end

      it 'returns ingredient categories' do
        json.each do |ingredient|
          category = ingredient['ingredient_category']
          expect(category['name']).to eq ingredient_category_name
          expect(category['id']).to eq ingredient_category_id
        end
      end
    end

  end

  # spec for GET /ingredient_categories/:id/ingredients
  describe 'GET /ingredient_categories/:ingredient_category_id/ingredients' do
  
    before { get "/ingredient_categories/#{ingredient_category_id}/ingredients" }

    context 'when category exists' do          
      it 'returns status code 200' do
        expect(response).to have_http_status 200 
      end

      it 'returns all ingredients in that category' do
        expect(json.size).to eq 10
      end
    end

    context 'when category does not exist' do
      let(:ingredient_category_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status 404
      end

      it 'returns a not found message' do
        expect(response.body).to match /Couldn't find IngredientCategory/
      end
    end
   
  end

  # spec for GET /ingredients/:id
  describe 'GET /ingredients/:id' do
 
    before { get "/ingredients/#{id}" }

    context 'when ingredient exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status 200
      end
      
      it 'returns the ingredient' do
        expect(json['id']).to eq id
      end
    end

    context 'when ingredient does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status 404
      end

      it 'returns a not found message' do
        expect(response.body).to match /Couldn't find Ingredient/
      end
    end
   
  end

  # spec for POST /ingredient_categories/:ingredient_category_id/ingredients
  describe 'POST /ingredient_categories/:ingredient_category_id/ingredients' do
  
    let(:valid_attrs) { {name: 'milk'} }
     
    context 'when request attributes are valid' do
      before { post "/ingredient_categories/#{ingredient_category_id}/ingredients", params: valid_attrs }

      it 'returns status code 201' do
        expect(response).to have_http_status 201
      end
    end

    context 'when request attributes are invalid' do
      before { post "/ingredient_categories/#{ingredient_category_id}/ingredients/", params: {} }

      it 'returns status code 422' do
        expect(response).to have_http_status 422
      end

      it 'returns a failure message' do
        expect(response.body).to match /Validation failed: Name can't be blank/
      end
    end
   
  end

  # spec for PUT /ingredients/:id
  describe 'PUT /ingredients/:id' do      

    let(:valid_attrs) { {name: 'Fishsticks'} }
    before { put "/ingredients/#{id}", params: valid_attrs }

    context 'when ingredient exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status 204
      end

      it 'updates the ingredient' do
         updated_ingredient = Ingredient.find(id)
         expect(updated_ingredient.name).to match /Fishsticks/ 
      end
    end

    context 'when ingredient does not exist' do
      let(:id) { 0 }
      it 'returns status code 404' do
        expect(response).to have_http_status 404
      end

      it 'returns a not found message' do
        expect(response.body).to match /Couldn't find Ingredient/
      end
    end

  end

  # spec for DELETE /ingredients/:id
  describe 'DELETE /ingredients/:id' do

    before { delete "/ingredients/#{id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status 204
    end

  end

end
