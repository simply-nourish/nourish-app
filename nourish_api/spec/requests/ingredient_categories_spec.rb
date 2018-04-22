# ingredient_category request spec
# /spec/request/ingredient_categories_spec.rb
# test methods adapted from: https://scotch.io/tutorials/build-a-restful-json-api-with-rails-5-part-one

require 'rails_helper'

RSpec.describe 'IngredientCategory API', type: :request do
  let!(:ingredient_categories) { create_list(:ingredient_category, 10) }
  let(:ingredient_category_id) { ingredient_categories.first.id }

  # spec for GET/ingredient_categories
  describe 'GET /ingredient_categories' do

    before { get '/ingredient_categories' }

    it 'returns ingredient_categories' do
      expect(json).not_to be_empty
      expect(json.size).to eq 10
    end

    it 'returns status 200' do  
      expect(response).to have_http_status 200
    end
 
  end 

  # spec for GET /ingredient_categories/:id
  describe 'GET /ingredient_categories/:id' do
 
    before { get "/ingredient_categories/#{ingredient_category_id}" }

    # expect a request for category id of :ingredient_category_id
    context 'when the record exists' do
      it 'returns the ingredient' do
        expect(json).not_to be_empty
        expect(json['id']).to eq ingredient_category_id
      end

      it 'returns status code 200' do
        expect(response).to have_http_status 200
      end
    end
  
    context 'when the record does not exist' do
      let(:ingredient_category_id) { 99 }

      it 'returns status code 404' do
        expect(response).to have_http_status 404
      end

      it 'returns not found message' do
        expect(response.body).to match /Couldn't find IngredientCategory/
      end
    end    
 
  end

  # spec for POST /ingredient_categories
  describe 'POST /ingredient_categories' do
  
    let(:valid_attributes) { {name: 'Dairy'} }

    context 'when request is valid' do
      before { post '/ingredient_categories', params: valid_attributes}

      it 'creates an ingredient category' do
        expect( json['name'] ).to eq 'Dairy'
      end

      it 'returns status code 201' do
        expect(response).to have_http_status 201
      end
    end

    context 'when request is invalid' do
      before { post '/ingredient_categories', params: { } }

      it 'returns status code 422' do
        expect(response).to have_http_status 422
      end

      it 'returns validation failure message' do
        expect(response.body).to match /Validation failed: Name can't be blank/
      end
    end
 
  end


  # spec for PUT /ingredient_categories/:id
  describe 'PUT /ingredient_categories/:id' do

    let(:valid_attributes) { {name: 'Dairy'} } 

    context 'when record exists' do
      before { put "/ingredient_categories/#{ingredient_category_id}", params: valid_attributes}

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status 204
      end
    end

  end

  # spec for DELETE /ingredient_categories/:id
  describe 'DELETE /ingredient_categories/:id' do

    before { delete "/ingredient_categories/#{ingredient_category_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status 204 
    end
  
  end

end
  
