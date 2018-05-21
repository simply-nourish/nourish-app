# request spec helpers
# /spec/support/request_spec_helper.rb
# source: https://scotch.io/tutorials/build-a-restful-json-api-with-rails-5-part-one

module RequestSpecHelper

  # create json method to shorten JSON.parse syntax
  def json
    JSON.parse(response.body)
  end

  # create a single recipe
  def create_full_recipe(user, num_ingredients, num_restrictions)
     
    recipe = create(:recipe, user_id: user.id)

    ingredient_category = create(:ingredient_category)
    ingredients = create_list(:ingredient, num_ingredients, ingredient_category_id: ingredient_category.id)
    measure = create(:measure)

    dietary_restrictions = create_list(:dietary_restriction, num_restrictions)
    
    ingredients.each do |ing|
      create(:ingredient_recipe, recipe_id: recipe.id, ingredient_id: ing.id, measure_id: measure.id)
    end

    dietary_restrictions.each do |rest|
      create(:dietary_restriction_recipe, recipe_id: recipe.id, dietary_restriction_id: rest.id)    
    end
  
    return recipe
    
  end

  # create list of recipes

  def create_recipe_list(user, num_recipes, num_ingredients, num_restrictions)
    recipe_list = Array.new
    num_recipes.times do
      recipe_list << create_full_recipe(user, num_ingredients, num_restrictions)
    end

    return recipe_list

  end

  #
  # create a meal plan + assign recipes, given a user and a list of recipes
  #

  def create_meal_plan(user, recipes) 

    # create a recipe with random ingredients, restrictions
    meal_plan = create(:meal_plan, user_id: user.id)
    recipes.each do |rec|
      create(:meal_plan_recipe, recipe_id: rec.id, meal_plan_id: meal_plan.id)
    end 

    return meal_plan

  end 

  def create_meal_plan_list(user, num_meal_plans, recipes_per_meal_plan) 

    meal_plan_list = Array.new
    num_meal_plans.times do
      recipes = create_list(:recipe, recipes_per_meal_plan, user_id: user.id)
      meal_plan_list << create_meal_plan(user, recipes)
    end 

    return meal_plan_list

  end 

end
