# request spec helpers
# /spec/support/request_spec_helper.rb
# source: https://scotch.io/tutorials/build-a-restful-json-api-with-rails-5-part-one

module RequestSpecHelper

  # create json method to shorten JSON.parse syntax
  def json
    JSON.parse(response.body)
  end

  #
  # create a single recipe
  # note: ingredient_measures param is formatted as a hash, with: :ingredient_id => [measure_id, amount]
  #

  def create_full_recipe(user, ingredient_measures, restrictions = [])
     
    # create a new recipe
    recipe = create(:recipe, user_id: user.id)

    # link to join tables 
    ingredient_measures.each do |key, value|
      create(:ingredient_recipe, recipe_id: recipe.id, ingredient_id: key, \
              measure_id: value.first, amount: value.second)
    end

    restrictions.each do |rest|
      create(:dietary_restriction_recipe, recipe_id: recipe.id, dietary_restriction_id: rest.id)    
    end
  
    return recipe
    
  end

  #
  # create list of recipes
  #

  def create_recipe_list(user, num_recipes, num_ingredients, num_restrictions)
    
    recipe_list = Array.new

    num_recipes.times do

      # create map to store :ingredient_id => [measure_id, amount] 
      ingredient_measures = {}

      # create ingredients
      ingredient_category = create(:ingredient_category)
      ingredients = create_list(:ingredient, num_ingredients, ingredient_category_id: ingredient_category.id)

      # attach ingredients to a unit of measure
      ingredients.each do |ing|
        meas = create(:measure)

        meas_arr = [ meas.id, Faker::Number.decimal(3) ]
        ing_id = ing.id

        ingredient_measures[ ing_id ] = meas_arr
      end 

      # create dietary restrictions
      dietary_restrictions = create_list(:dietary_restriction, num_restrictions)

      # create a recipe with these specs, append to our list of recipes
      recipe_list << create_full_recipe(user, ingredient_measures, dietary_restrictions)
   
    end

    return recipe_list

  end

  #
  # create a meal plan + assign recipes, given a user and a list of recipes
  #

  def create_meal_plan(user, recipes) 

    days = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]
    meals = ["breakfast", "lunch", "dinner", "snack"]

    i = 0
    j = 0

    # create a recipe with random ingredients, restrictions
    meal_plan = create(:meal_plan, user_id: user.id)
    recipes.each do |rec|
      create(:meal_plan_recipe, recipe_id: rec.id, meal_plan_id: meal_plan.id, day: days[i], meal: meals[j])
      i = (i + 1) % days.length
      if i == 0 
        j = j + 1
      end
    end 

    return meal_plan

  end 

  #
  # create a list of meal plans + assign recipes, given a user along with specs re: how to construct the list of recipes
  #

  def create_meal_plan_list(user, num_meal_plans = 5, recipes_per_meal_plan = 1, ingredients_per_recipe = 1, restrictions_per_recipe = 0) 

    meal_plan_list = Array.new
    num_meal_plans.times do
      recipes = create_recipe_list(user, recipes_per_meal_plan, ingredients_per_recipe, restrictions_per_recipe)
      meal_plan_list << create_meal_plan(user, recipes)
    end 

    return meal_plan_list

  end 

  #
  # create a shopping list, given a user + a meal plan
  #

  def create_shopping_list(user, name, meal_plan)

    ing_amt_map = {}

    shopping_list = create(:shopping_list, user_id: user.id, name: name, meal_plan_id: meal_plan.id )
    
    meal_plan.recipes.each do |rec|

      # fetch ingredient_recipes
      @recipe = Recipe.find(rec.id)   
        ingredient_recipes = @recipe.ingredient_recipes
        ingredient_recipes.each do |ing_rec|

          # the key for each entry in our map will be the combination of (ingredient_id, measure_id) 
          ing_measure = [ing_rec.ingredient_id, ing_rec.measure_id]

          # check if the key exists - if so, add associated amount
          # if the key does not exist, create new entry in map
          if( ing_amt_map.key?(ing_measure) )
            ing_amt_map[ ing_measure ] += ing_rec.amount
          else
            ing_amt_map[ ing_measure ] = ing_rec.amount
          end

        end 

    end 

    # now, create ingredient_shopping_lists with aggregated data
    ing_amt_map.each do |key, agg_amount|
      create(:ingredient_shopping_list, shopping_list_id: shopping_list.id, ingredient_id: key.first, measure_id: key.second, \
              amount: agg_amount, purchased: false)
    end 

    return shopping_list

  end

end
