# measures request spec
# /spec/request/measures.rb
# test methods adapted from: https://scotch.io/tutorials/build-a-restful-json-api-with-rails-5-part-one

require 'rails_helper'

RSpec.describe 'Measures API', type: :request do
  let!(:measures) { create_list(:measure, 10) }
  let(:measure_id) { measures.first.id }

  # spec for GET/measures
  describe 'GET /measures' do

    before { get '/measures' }

    it 'returns measures' do
      expect(json).not_to be_empty
      expect(json.size).to eq 10
    end

    it 'returns status 200' do  
      expect(response).to have_http_status 200
    end
 
  end 

  # spec for GET /measures/:id
  describe 'GET /measures/:id' do
 
    before { get "/measures/#{measure_id}" }

    # expect a request for category id of :measure_id
    context 'when the record exists' do
      it 'returns the restriction' do
        expect(json).not_to be_empty
        expect(json['id']).to eq measure_id
      end

      it 'returns status code 200' do
        expect(response).to have_http_status 200
      end
    end
  
    context 'when the record does not exist' do
      let(:measure_id) { -1 }

      it 'returns status code 404' do
        expect(response).to have_http_status 404
      end

      it 'returns not found message' do
        expect(response.body).to match /Couldn't find Measure/
      end
    end    
 
  end

  # spec for POST /measures
  describe 'POST /measures' do
  
    let(:valid_attributes) { {name: 'Teaspoons'} }

    context 'when request is valid' do
      before { post '/measures', params: valid_attributes}

      it 'creates a masure' do
        expect( json['name'] ).to eq 'Teaspoons'
      end

      it 'returns status code 201' do
        expect(response).to have_http_status 201
      end
    end

    context 'when request is invalid' do
      before { post '/measures', params: { } }

      it 'returns status code 422' do
        expect(response).to have_http_status 422
      end

      it 'returns validation failure message' do
        expect(response.body).to match /Validation failed: Name can't be blank/
      end
    end
 
  end

  # spec for PUT /measures/:id
  describe 'PUT /measures/:id' do

    let(:valid_attributes) { {name: 'Teaspoons'} } 

    context 'when record exists' do
      before { put "/measures/#{measure_id}", params: valid_attributes}

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status 204
      end
    end
    
    context 'when record does not exist' do
      let(:restriction_id) { 0 }
      before { put "/measures/#{restriction_id}", params: valid_attributes}
      
      it 'returns status code 404' do
        expect(response).to have_http_status 404
      end

      it 'returns a not found message' do
        expect(response.body).to match /Couldn't find Measure/
      end
    end

  end

  # spec for DELETE /measures/:id
  describe 'DELETE /measures/:id' do

    before { delete "/measures/#{measure_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status 204 
    end
  
  end

end
  
