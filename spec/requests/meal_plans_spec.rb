# meal plans request spec
# /spec/requests/meal_plans_spec.rb
# test methods adapted from https://scotch.io/tutorials/build-a-restful-json-api-with-rails-5-part-one

require 'rails_helper'
require 'support/request_spec_helper'
require 'json'

RSpec.describe 'MealPlans API', type: :request do

  let(:meal_plans_per_user) { 2 }
  let(:recipes_per_meal_plan) { 2 }

  let!(:user_1) { create(:user) } 
  subject { auth_post user_1, '/auth', params: {  email: user_1.email,
                                                  password: user_1.password,
                                                  password_confirmation: user_1.password, 
                                                  confirm_success_url: "www.google.com" } }

  let!(:user_2) { create(:user) }

  let!(:user_1_meal_plan) { create_meal_plan_list(user_1, meal_plans_per_user, recipes_per_meal_plan) }
  let!(:user_2_meal_plan) { create_meal_plan_list(user_2, meal_plans_per_user, recipes_per_meal_plan) }

  let!(:user_1_first_mp_id) { user_1_meal_plan.first.id }
  let!(:uid1) { user_1.id }

  let!(:user_2_first_mp_name) { user_2_meal_plan.first.name }
  let!(:user_2_first_mp_id) { user_2_meal_plan.first.id}
  
  #
  # spec for GET /users/:id/meal_plans
  #

  describe "GET /users/:id/meal_plans" do
    before { auth_get user_1, "/users/#{uid1}/meal_plans", params: {} }

    context 'when meal plans are in database' do

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all of that user\'s meal plans' do
        expect(json.size).to eq meal_plans_per_user      
      end

      it 'returns all recipes in each meal_plan' do
        json.each do |mp|
          meal_plan_recipes = mp['meal_plan_recipes']
          expect(meal_plan_recipes.size).to eq recipes_per_meal_plan
        end
      end

    end # end context

    context 'when user retrieves meal plans not belonging to them' do 
      let( :uid1 ) { user_2.id }

      it 'returns status code unauthorized' do
        expect(response).to have_http_status(401)
      end 
    end # end context

  end # end describe

  #
  # spec for GET users/:id/meal_plans/:id
  #

  describe "GET users/:id/meal_plans/:id" do
    before { auth_get user_1, "/meal_plans/#{user_1_first_mp_id}", params: {} }

    context 'when recipe exists' do

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
      
      it 'returns the recipe' do
        expect(json['id']).to eq user_1_first_mp_id
      end

    end

    context 'when recipe record does not exist' do
 
      let(:user_1_first_mp_id) { -1 }
     
      it 'returns status code 404' do
        expect(response).to have_http_status 404
      end

      it 'returns not found message' do
        expect(response.body).to match /Couldn't find MealPlan/
      end 
      
    context 'when user retrieves meal plan not belonging to them' do 
      let(:user_1_first_mp_id) { user_2_first_mp_id }

      it 'returns status code unauthorized' do
        expect(response).to have_http_status(401)
      end 
    end

    end # end context
      
  end # end describe block

  #
  # spec for POST /users/:id/meal_plans
  #

  describe 'POST /users/:id/meal_plans' do
  
    # creating some test data...building known good data 

    let!(:recipe) { create(:recipe, user: user_1 ) }
    let!(:rec_id) { recipe.id }

    # use that data to build our meal_plan request
    let(:valid_attrs) { { :meal_plan => {
                           name: 'my plan',
                           meal_plan_recipes_attributes: [ {recipe_id: "#{rec_id}", day: "thursday", meal: "breakfast"} ]
                          }
                        }
                      }

    context 'when request attributes are valid' do
      before { auth_post user_1, "/users/#{user_1.id}/meal_plans", params: valid_attrs }

      it 'returns status code 201' do
        expect(response).to have_http_status 201
      end
    end

    context 'when request attributes are invalid' do
      before { auth_post user_1, "/users/#{user_1.id}/meal_plans", params: {} }

      it 'returns status code 400' do
        expect(response).to have_http_status 400
      end
    end

    context 'when user is not authorized to POST' do
      before { auth_post user_1, "/users/#{user_2.id}/meal_plans", params: {} }

      it 'returns unauthorized' do
        expect(response).to have_http_status 401
      end
    end 
 
  end # end describe block

  #
  # spec for PUT /meal_plans
  #

  describe "PUT /meal_plans/:id" do

    let(:valid_attrs) { { :meal_plan => { name: 'my revised meal plan' } } }
    before { auth_put user_1, "/meal_plans/#{user_1_first_mp_id}", params: valid_attrs }

    context 'when meal plan exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status 204
      end

      it 'updates the meal plan' do
        updated_meal_plan = MealPlan.find(user_1_first_mp_id)
        expect(updated_meal_plan.name).to match /my revised meal plan/
      end
    end # end context

    context 'when meal plan does not exist' do

      let(:user_1_first_mp_id) { -1 }
      it 'returns status code 404' do
        expect(response).to have_http_status 404
      end

      it 'returns a not found message' do
        expect(response.body).to match /Couldn't find MealPlan/
      end

    end # end context

    context 'when user not authorized to PUT' do
      before { auth_put user_1, "/meal_plans/#{user_2.meal_plans.first.id}", params: valid_attrs }
      let!(:prevname) { user_2_first_mp_name }

      it 'returns unauthorized' do
        expect(response).to have_http_status 401
      end

      it 'has not modified the name' do
        expect(user_2.meal_plans.first.name).to eq prevname
      end

    end # end ontext 

  end # end describe block

  #
  # spec for DELETE /recipes
  #

  describe 'DELETE /meal_plans/:id' do

    context 'when authorized user attempts to delete' do

      before { auth_delete user_1, "/meal_plans/#{user_1_first_mp_id}", params: {} }
  
      it 'returns status code 204' do
        expect(response).to have_http_status 204
      end

    end

    context 'when unauthorized user attempts to delete' do
      
      before { auth_delete user_1, "/meal_plans/#{user_2_first_mp_id}", params: {} }

      it 'returns unauthorized' do
        expect(response).to have_http_status 401
      end 

    end

  end # end describe block

end # end test
