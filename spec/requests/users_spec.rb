# spec/requests/users_spec.rb
# User request specs (incl. Devise / auth)

include ActionController::RespondWith

require 'rails_helper'
require 'support/request_spec_helper'
require 'json'

RSpec.describe 'Users API', type: :request do

  before(:each) do
    @user = create(:user)
    auth_post @user, "/auth", params: {  nickname: @user.nickname,
                                         email: @user.email,
                                         password: @user.password,
                                         password_confirmation: @user.password, 
                                         confirm_success_url: "www.google.com" }
  end
  
  context 'signing in the user' do
    before { auth_post @user, '/auth/sign_in', params: { email: @user.email, password: @user.password } }

    it 'gives status code of 200 on signin' do
      expect(response).to have_http_status(200)
    end

    it 'gives you an auth code if you are existing user / satisfy password' do
      expect(response.has_header?('access-token')).to eq(true)
    end
    
  end # end context

  context 'getting all user information (GET /users)' do
    before { auth_post @user, '/auth/sign_in', params: { email: @user.email, password: @user.password } }

    it 'produces correct number of users from /users query' do
      auth_get @user, '/users', params: {}
      expect(json.size).to eq 1 # only one user      
    end 

    it 'produces abbreviated information (no specifics)' do
      auth_get @user, '/users', params: {}
      expect(json.first).to_not have_key("email")
    end

  end # end context

  context 'getting one user\'s information (GET /users/:id)' do
    before { auth_post @user, '/auth/sign_in', params: { email: @user.email, password: @user.password } }
    
    it 'returns status code 200 if user is authenticated' do
      auth_get @user, "/users/#{@user.id}", params: {}
      expect(response).to have_http_status(200)
    end

    it 'produces expanded info when user id matches current_user' do
      auth_get @user, "/users/#{@user.id}", params: {}
      expect(json).to have_key("email")
    end

    it 'produces abbreviated info when user id does not match current_user' do
      @new_user = create(:user)
      auth_get @user, "/users/#{@new_user.id}", params: {}
      expect(json).to_not have_key("email") 
    end

    it 'returns status code 401 if user is not authenticated' do
      get "/users/#{@user.id}" 
      expect(response).to have_http_status(401)
    end

    it 'returns status code 404 if user does not exist' do
      get "/users/-1" 
      expect(response).to have_http_status(401)
    end

  end # end context

  context 'modifying user account (PUT /auth)' do
    before { auth_post @user, '/auth/sign_in', params: { email: @user.email, password: @user.password } }

    it 'responds with status code 200' do
      auth_put @user, "/auth", params: { nickname: "foobar" }
      expect(response).to have_http_status 200
    end

    it 'allows user to modify their nickname' do
      new_name = "l33thx"
      auth_put @user, "/auth", params: { nickname: new_name }
      expect(json["data"]["nickname"]).to eq new_name
    end

    it 'allows user to modify their email' do
      new_email = "l33thx@gmail.com"
      auth_put @user, "/auth", params: { email: new_email }
      expect(json["data"]["email"]).to eq new_email
    end

    it 'returns status code 404 if user is not authenticated' do
      put "/auth", params: { nickname: "randy" } 
      expect(response).to have_http_status(404)
    end
    
  end # end context

  context 'deleting user account (DELETE /auth)' do
    before { auth_post @user, '/auth/sign_in', params: { email: @user.email, password: @user.password } }
    let!(:access_token) { response.header["access-token" ] }
    let!(:client) { response.header["client"] }
    let!(:uid) { response.header["uid"] }

    it 'produces status code of 200 on successful deletion' do
      auth_delete @user, "/auth", params: {  }
      expect(response).to have_http_status 200
    end

    it 'allows user to delete their account' do
      auth_delete @user, "/auth", params: {  }
      get "/users/#{@user.id}", params: { }
      expect(response).to have_http_status 401
    end

  end # end context

  context 'signing out (DELETE /auth/sign_out)' do
    before { auth_post @user, '/auth/sign_in', params: { email: @user.email, password: @user.password } }
    let!(:access_token) { response.header["access-token" ] }
    let!(:client) { response.header["client"] }
    let!(:uid) { response.header["uid"] }

    it 'produces status code of 200 0n successful signout' do
      auth_delete @user, '/auth/sign_out', headers: { "access-token" => :access_token, "client" => :client, "uid" => :uid }
      expect(response).to have_http_status 200
    end 

    it 'allows user to sign out' do
      auth_delete @user, '/auth/sign_out', headers: { "access-token" => :access_token, "client" => :client, "uid" => :uid }
      put '/auth', params: { nickname: "shouldn't work" }, headers: { "access-token" => :access_token, "client" => :client, "uid" => :uid }
      expect(response).to have_http_status 404
    end


  end # end context
end # end describe
