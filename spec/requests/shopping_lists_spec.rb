# shopping lists request spec
# /spec/requests/shopping_lists_spec.rb
# test methods adapted from https://scotch.io/tutorials/build-a-restful-json-api-with-rails-5-part-one

require 'rails_helper'
require 'support/request_spec_helper'
require 'json'

RSpec.describe 'ShoppingList API', type: :request do

  #
  # initial test setup 
  #

  let(:shopping_lists_per_user) { 1 }
  let(:meal_plans_per_user) { 1 }

  let(:recipes_per_meal_plan) { 2 }
  let(:ingredients_per_recipe) { 2 }

  # create primary user account
  let!(:user_1) { create(:user) } 
  let!(:uid1) { user_1.id }
  subject { auth_post user_1, '/auth', params: {  email: user_1.email,
                                                  password: user_1.password,
                                                  password_confirmation: user_1.password, 
                                                  confirm_success_url: "www.google.com" } }

  # create secondary user account
  let!(:user_2) { create(:user) }

  # populate user one's meal plans
  let!(:user_1_meal_plans) { create_meal_plan_list(user_1, meal_plans_per_user, recipes_per_meal_plan, ingredients_per_recipe) }
  let!(:user_1_first_mp ) { user_1_meal_plans.first }

  # populate user two's meal plans
  let!(:user_2_meal_plans) { create_meal_plan_list(user_2, meal_plans_per_user, recipes_per_meal_plan, ingredients_per_recipe) }
  let!(:user_2_first_mp ) { user_2_meal_plans.first }

  ##########################
  # spec for GET /users/:id/shopping_lists
  ##########################

  describe "GET /users/:id/shopping_lists" do

    let!(:shopping_list) { create_shopping_list( user_1, "my shopping list", user_1_first_mp ) }

    context 'when shopping_lists are in database' do
      before { auth_get user_1, "/users/#{uid1}/shopping_lists", params: {} }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all of that user\'s shopping lists' do
        expect(json.size).to eq (shopping_lists_per_user)      
      end

      it 'returns the appropriate shopping list name' do
        expect(json.first['name']).to match /my shopping list/
      end

      it 'returns all ingredients in each shopping list' do
        json.each do |sl|
          ingredient_shopping_lists = sl['ingredient_shopping_lists']
          expect(ingredient_shopping_lists.size).to eq (recipes_per_meal_plan * ingredients_per_recipe)
        end
      end

    end # end context

    context 'when user retrieves shopping list not belonging to them' do 
      before { auth_get user_1, "/users/#{user_2.id}/shopping_lists", params: {} }

      it 'returns status code unauthorized' do
        expect(response).to have_http_status(401)
      end 
    end # end context

  end # end describe

  ##########################
  # spec for GET users/:id/shopping_lists/:id
  ##########################
  
  describe "GET users/:id/shopping_lists/:id" do

    let!(:user_1_shopping_list) { create_shopping_list( user_1, "my shopping list", user_1_first_mp ) }
    let!(:shopping_list_size) { 5 }

    context 'when recipe exists' do 
      before { auth_get user_1, "/shopping_lists/#{user_1_shopping_list.id}", params: {} }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
      
      it 'returns the shopping list' do
        expect(json['id']).to eq user_1_shopping_list.id
      end

      it 'returns one record' do
        expect(json.size).to eq shopping_list_size
      end 
    end # end context

    context 'when recipe record does not exist' do
      before { auth_get user_1, "/shopping_lists/#{-3}", params: {} }

      it 'returns status code 404' do
        expect(response).to have_http_status 404
      end

      it 'returns not found message' do
        expect(response.body).to match /Couldn't find ShoppingList/
      end 
    end # end context
      
    context 'when user retrieves shopping list not belonging to them' do 
      before { auth_get user_2, "/shopping_lists/#{user_1_shopping_list.id}", params: {} }

      it 'returns status code unauthorized' do
        expect(response).to have_http_status(401)
      end 
    end # end context
      
  end # end describe block

  ##########################
  # spec for POST /users/:id/shopping_lists
  ##########################

  describe 'POST /users/:id/shopping_lists' do
      
    #
    # INGREDIENT AGGREGATION TEST SETUP:
    #

    let(:unique_ingredients) { 3 }

    # create known recipes to test aggregation for shopping list
    let!(:cups) { create(:measure, name: "cups") }

    let!(:dairy) { create(:ingredient_category, name: "dairy") }

    let!(:milk) { create(:ingredient, name: "milk", ingredient_category_id: dairy.id) }
    let!(:cheese) { create(:ingredient, name: "cheese", ingredient_category_id: dairy.id) }
    let!(:yogurt) { create(:ingredient, name: "yogurt", ingredient_category_id: dairy.id) }

    let!(:recipe_1_ing_hash) { { milk.id => [cups.id, 1.5], cheese.id => [cups.id, 0.5] } }
    let!(:recipe_2_ing_hash) { { milk.id => [cups.id, 0.5], cheese.id => [cups.id, 1.5], yogurt.id => [cups.id, 2.0] } }

    # create known recipes
    let!(:user_1_recipe_1) { create_full_recipe(user_1, recipe_1_ing_hash) }
    let!(:user_1_recipe_2) { create_full_recipe(user_1, recipe_2_ing_hash) }
    let!(:user_1_recipes) { [user_1_recipe_1, user_1_recipe_2] }
  
    # create, assign a meal plan to user one
    let!(:user_1_meal_plan) { create_meal_plan(user_1, user_1_recipes) }

    # use that data to build our meal_plan request
    let(:valid_attrs) { {:shopping_list => {
                           name: 'my shopping list',
                           meal_plan_id: user_1_meal_plan.id
                           } 
                        }
                      }

    #
    # RUNNING POST ROUTE TESTS:
    #

    context 'when request attributes are valid' do
      before { auth_post user_1, "/users/#{user_1.id}/shopping_lists", params: valid_attrs }

      it 'returns status code 201' do
        expect(response).to have_http_status 201
      end

      it 'returns all ingredients in the created shopping list' do
        expect(json['ingredient_shopping_lists'].size).to eq (unique_ingredients)
      end

      it 'returns appropriate amount' do
        ingredient_shopping_lists = json['ingredient_shopping_lists']
        ingredient_shopping_lists.each do |ing_sl|
          expect(ing_sl["amount"]).to eq 2.0
        end 
      end 

      it 'returns all newly-created items as not purchased' do
        ingredient_shopping_lists = json['ingredient_shopping_lists']
        ingredient_shopping_lists.each do |ing_sl|
          expect(ing_sl["purchased"]).to eq false
        end
      end
      
    end # end context

    context 'when request attributes are invalid' do
      before { auth_post user_1, "/users/#{user_1.id}/shopping_lists", params: {} }

      it 'returns status code 400' do
        expect(response).to have_http_status 400
      end
    end # end context

    context 'when user is not authorized to POST' do
      before { auth_post user_1, "/users/#{user_2.id}/shopping_lists", params: {} }

      it 'returns unauthorized' do
        expect(response).to have_http_status 401
      end
    end # end context
 
  end # end describe block

  ##########################
  # spec for PUT /shopping/lists/:id
  ##########################

  describe "PUT /shopping_lists/:id" do

    #
    # TEST SETUP
    #

    let(:unique_ingredients) { 3 }

    # create known recipes to test aggregation for shopping list
    let!(:cups) { create(:measure, name: "cups") }
    let!(:dairy) { create(:ingredient_category, name: "dairy") }
    
    let!(:milk) { create(:ingredient, name: "milk", ingredient_category_id: dairy.id) }
    let!(:cheese) { create(:ingredient, name: "cheese", ingredient_category_id: dairy.id) }
    let!(:yogurt) { create(:ingredient, name: "yogurt", ingredient_category_id: dairy.id) }

    let!(:recipe_1_ing_hash) { { milk.id => [cups.id, 1.5], cheese.id => [cups.id, 0.5], yogurt.id => [cups.id, 0.25] } }
    let!(:recipe_2_ing_hash) { { milk.id => [cups.id, 0.5], cheese.id => [cups.id, 1.5], yogurt.id => [cups.id, 1.75] } }

    # create known recipes
    let!(:user_1_recipe_1) { create_full_recipe(user_1, recipe_1_ing_hash) }
    let!(:user_1_recipe_2) { create_full_recipe(user_1, recipe_2_ing_hash) }
    let!(:user_1_recipes) { [user_1_recipe_1, user_1_recipe_2] }
  
    # create, assign a meal plan + shoppinglist to user one
    let!(:user_1_meal_plan) { create_meal_plan(user_1, user_1_recipes) }
    let!(:user_1_shopping_list) { create_shopping_list( user_1, "my shopping list",  user_1_meal_plan) }
   
    # create randomized shopping list for user 2
    let!(:user_2_shopping_list) { create_shopping_list( user_2, "user 2 shopping list", user_2_first_mp ) }
    let!(:prevname) { user_2_shopping_list.name }

    # create JSON for testing
    let(:valid_attrs) { 
                        { 
                          shopping_list:  { 
                                            name: 'my revised shopping list',
                                            ingredient_shopping_lists_attributes: [ { ingredient_id: "#{milk.id}", measure_id: "#{cups.id}", amount: '2.0', purchased: true },
                                                                                    { ingredient_id: "#{yogurt.id}", measure_id: "#{cups.id}", _destroy: '1' } ]
                                          }
                        } 
                      }

    context 'when shopping list exists' do
      before { auth_put user_1, "/shopping_lists/#{user_1_shopping_list.id}", params: valid_attrs }
     
      it 'returns status code 204' do
        expect(response).to have_http_status 204
      end

      it 'updates the shopping list' do
        updated_shopping_list = ShoppingList.find(user_1_shopping_list.id)
        expect(updated_shopping_list.name).to match /my revised shopping list/
      end

      it 'can update purchased field' do
        milk_purchased_check = IngredientShoppingList.find_by(shopping_list: user_1_shopping_list, ingredient: milk)
        expect(milk_purchased_check.purchased).to eq true
      end 

      it 'does not updated other purchased fields' do
        cheese_purchased_check = IngredientShoppingList.find_by(shopping_list: user_1_shopping_list, ingredient: cheese)
        expect(cheese_purchased_check.purchased).to eq false
      end

      it 'allows for one ingredient to be modified at a time' do
        updated_shopping_list = ShoppingList.find(user_1_shopping_list.id)
        expect(updated_shopping_list.ingredient_shopping_lists.size()).to eq (unique_ingredients - 1)
      end

      it 'destroys the appropriate ingredient from the list' do
        destroyed_shopping_list = IngredientShoppingList.find_by(shopping_list: user_1_shopping_list, ingredient: yogurt)
        expect(destroyed_shopping_list).to eq nil
      end 
    end # end context

    context 'when shopping list does not exist' do
      before { auth_put user_1, "/shopping_lists/-1", params: valid_attrs }

      it 'returns status code 404' do
        expect(response).to have_http_status 404
      end

      it 'returns a not found message' do
        expect(response.body).to match /Couldn't find ShoppingList/
      end
    end # end context

    context 'when user not authorized to PUT' do
      before { auth_put user_1, "/shopping_lists/#{user_2_shopping_list.id}", params: valid_attrs }

      it 'returns unauthorized' do
        expect(response).to have_http_status 401
      end

      it 'has not modified the name' do
        expect(user_2_shopping_list.name).to eq prevname
      end
    end # end context 

  end # end describe block

  ##########################
  # spec for DELETE /shopping_lists/:id
  ##########################

  describe 'DELETE /shopping_lists/:id' do

    let!(:user_1_shopping_list) { create_shopping_list( user_1, "user 1 shopping list", user_1_first_mp ) }
    let!(:user_2_shopping_list) { create_shopping_list( user_2, "user 2 shopping list", user_2_first_mp ) }

    context 'when authorized user attempts to delete' do
      before { auth_delete user_1, "/shopping_lists/#{user_1_shopping_list.id}", params: {} }
  
      it 'returns status code 204' do
        expect(response).to have_http_status 204
      end

      it 'deletes associated ingredient_shopping_lists entries' do
        expect(IngredientShoppingList.find_by(shopping_list_id: user_1_shopping_list.id)).to be nil
      end
    end # end context

    context 'when unauthorized user attempts to delete' do   
      before { auth_delete user_1, "/shopping_lists/#{user_2_shopping_list.id}", params: {} }

      it 'returns unauthorized' do
        expect(response).to have_http_status 401
      end 
    end # end context

  end # end describe block

end # end test
