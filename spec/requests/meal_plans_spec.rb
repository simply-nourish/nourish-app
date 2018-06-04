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

  let!(:user_1_meal_plans) { create_meal_plan_list(user_1, meal_plans_per_user, recipes_per_meal_plan) }
  let!(:user_2_meal_plans) { create_meal_plan_list(user_2, meal_plans_per_user, recipes_per_meal_plan) }

  let!(:user_1_first_mp) { user_1_meal_plans.first }
  let!(:uid1) { user_1.id }

  let!(:user_2_first_mp) { user_2_meal_plans.first}
  
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

    context 'when meal plan exists' do
      before { auth_get user_1, "/meal_plans/#{user_1_first_mp.id}", params: {} }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
      
      it 'returns the recipe' do
        expect(json['id']).to eq user_1_first_mp.id
      end

    end

    context 'when meal plan record does not exist' do
      before { auth_get user_1, "/meal_plans/-1", params: {} }
     
      it 'returns status code 404' do
        expect(response).to have_http_status 404
      end

      it 'returns not found message' do
        expect(response.body).to match /Couldn't find MealPlan/
      end 
      
    context 'when user retrieves meal plan not belonging to them' do 
      before { auth_get user_1, "/meal_plans/#{user_2_first_mp.id}", params: {} }

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
  # spec for PUT /meal_plans/:id
  #

  describe "PUT /meal_plans/:id" do

    # creating some test data...building known good data 

    # create known recipes to test aggregation for shopping list
    let!(:cups) { create(:measure, name: "cups") }
    let!(:dairy) { create(:ingredient_category, name: "dairy") }
    
    let!(:milk) { create(:ingredient, name: "milk", ingredient_category_id: dairy.id) }
    let!(:cheese) { create(:ingredient, name: "cheese", ingredient_category_id: dairy.id) }
    let!(:yogurt) { create(:ingredient, name: "yogurt", ingredient_category_id: dairy.id) }

    let!(:recipe_1_ing_hash) { { milk.id => [cups.id, 1.5], cheese.id => [cups.id, 0.5] } }    
    let!(:recipe_2_ing_hash) { { milk.id => [cups.id, 1.5], yogurt.id => [cups.id, 0.5] } }

    # create known recipes
    let!(:user_1_recipe_1) { create_full_recipe(user_1, recipe_1_ing_hash) }
    let!(:user_1_recipe_2) { create_full_recipe(user_1, recipe_2_ing_hash) }
   # let!(:user_1_recipes) { [user_1_recipe_1] }

    # create known meal_plans
    let!(:user_1_meal_plan) { create_meal_plan(user_1, [user_1_recipe_1]) }
    let!(:meal_plan_entry_1) { user_1_meal_plan.meal_plan_recipes.first }
   # let!(:meal_plan_entry_2) { user_1_meal_plan.meal_plan_recipes.second }

    let(:valid_attrs) { { meal_plan: { 
                                        name: 'my revised meal plan', 
                                        meal_plan_recipes_attributes: [ {recipe_id: "#{user_1_recipe_1.id}", day: meal_plan_entry_1.day, meal: meal_plan_entry_1.meal, _destroy: "1" },
                                                                        {recipe_id: "#{user_1_recipe_2.id}", day: "monday", meal: "lunch"} ] 
                                      } } }

    context 'when meal plan exists' do
      before { auth_put user_1, "/meal_plans/#{user_1_meal_plan.id}", params: valid_attrs }

      it 'returns status code 204' do
        expect(response).to have_http_status 204
      end

      it 'updates the meal plan\'s name' do
        updated_meal_plan = MealPlan.find(user_1_meal_plan.id)
        expect(updated_meal_plan.name).to match /my revised meal plan/
      end

      it 'destroys the appropriate meal plan entry' do
        destroyed_meal_plan_recipe = MealPlanRecipe.find_by(recipe: user_1_recipe_1)
        expect(destroyed_meal_plan_recipe).to eq nil
      end

      it 'adds the appropriate meal plan entry' do 
        new_meal_plan_recipe = MealPlanRecipe.find_by(recipe: user_1_recipe_2, day: "monday", meal: "lunch");
        expect(new_meal_plan_recipe).not_to eq nil
      end

    end # end context

    context 'when meal plan does not exist' do
      before { auth_put user_1, "/meal_plans/-1", params: valid_attrs }

      it 'returns status code 404' do
        expect(response).to have_http_status 404
      end

      it 'returns a not found message' do
        expect(response.body).to match /Couldn't find MealPlan/
      end
    end # end context

    context 'when user not authorized to PUT' do
      before { auth_put user_1, "/meal_plans/#{user_2_first_mp.id}", params: valid_attrs }
      let!(:prevname) { user_2_first_mp.name }

      it 'returns unauthorized' do
        expect(response).to have_http_status 401
      end

      it 'has not modified the name' do
        expect(user_2_first_mp.name).to eq prevname
      end
    end # end context 

  end # end describe block

  #
  # spec for DELETE /meal_plans/:id
  #

  describe 'DELETE /meal_plans/:id' do

    context 'when authorized user attempts to delete' do
      before { auth_delete user_1, "/meal_plans/#{user_1_first_mp.id}", params: {} }
  
      it 'returns status code 204' do
        expect(response).to have_http_status 204
      end
    end

    context 'when unauthorized user attempts to delete' do    
      before { auth_delete user_1, "/meal_plans/#{user_2_first_mp.id}", params: {} }

      it 'returns unauthorized' do
        expect(response).to have_http_status 401
      end 
    end

  end # end describe block

end # end test
