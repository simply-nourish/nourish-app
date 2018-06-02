# app/models/serializers/meal_plan_recipe_serializer.rb
# MealPlanRecipe model serializer

class MealPlanRecipeSerializer < ActiveModel::Serializer
  attributes :day, :meal
  has_one :recipe_id
  
  def recipe_id
    object.recipe.id
  end
  
end
