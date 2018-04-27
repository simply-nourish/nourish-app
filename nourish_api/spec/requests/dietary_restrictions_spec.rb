# dietary_restriction request spec
# /spec/request/dietary_restrictions_spec.rb
# test methods adapted from: https://scotch.io/tutorials/build-a-restful-json-api-with-rails-5-part-one

require 'rails_helper'

RSpec.describe 'DietaryRestriction API', type: :request do
  let!(:dietary_restrictions) { create_list(:dietary_restriction, 10) }
  let(:restriction_id) { dietary_restrictions.first.id }

  # spec for GET/dietary_restrictions
  describe 'GET /dietary_restrictions' do

    before { get '/dietary_restrictions' }

    it 'returns dietary_restrictions' do
      expect(json).not_to be_empty
      expect(json.size).to eq 10
    end

    it 'returns status 200' do  
      expect(response).to have_http_status 200
    end
 
  end 

  # spec for GET /dietary_restrictions/:id
  describe 'GET /dietary_restrictions/:id' do
 
    before { get "/dietary_restrictions/#{restriction_id}" }

    # expect a request for category id of :restriction_id
    context 'when the record exists' do
      it 'returns the restriction' do
        expect(json).not_to be_empty
        expect(json['id']).to eq restriction_id
      end

      it 'returns status code 200' do
        expect(response).to have_http_status 200
      end
    end
  
    context 'when the record does not exist' do
      let(:restriction_id) { 99 }

      it 'returns status code 404' do
        expect(response).to have_http_status 404
      end

      it 'returns not found message' do
        expect(response.body).to match /Couldn't find DietaryRestriction/
      end
    end    
 
  end

  # spec for POST /dietary_restrictions
  describe 'POST /dietary_restrictions' do
  
    let(:valid_attributes) { {name: 'Vegan'} }

    context 'when request is valid' do
      before { post '/dietary_restrictions', params: valid_attributes}

      it 'creates a restriction' do
        expect( json['name'] ).to eq 'Vegan'
      end

      it 'returns status code 201' do
        expect(response).to have_http_status 201
      end
    end

    context 'when request is invalid' do
      before { post '/dietary_restrictions', params: { } }

      it 'returns status code 422' do
        expect(response).to have_http_status 422
      end

      it 'returns validation failure message' do
        expect(response.body).to match /Validation failed: Name can't be blank/
      end
    end
 
  end


  # spec for PUT /dietary_restrictions/:id
  describe 'PUT /dietary_restrictions/:id' do

    let(:valid_attributes) { {name: 'Vegan'} } 

    context 'when record exists' do
      before { put "/dietary_restrictions/#{restriction_id}", params: valid_attributes}

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status 204
      end
    end
    
    context 'when record does not exist' do
      let(:restriction_id) { 0 }
      before { put "/dietary_restrictions/#{restriction_id}", params: valid_attributes}
      
      it 'returns status code 404' do
        expect(response).to have_http_status 404
      end

      it 'returns a not found message' do
        expect(response.body).to match /Couldn't find DietaryRestriction/
      end
    end

  end

  # spec for DELETE /dietary_restrictions/:id
  describe 'DELETE /dietary_restrictions/:id' do

    before { delete "/dietary_restrictions/#{restriction_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status 204 
    end
  
  end

end
  
