# app/models/serializers/meal_plan_recipe_serializer.rb
# MealPlanRecipe model serializer

class MealPlanRecipeSerializer < ActiveModel::Serializer
  attributes :id, :day, :meal
  has_one :recipe, :serializer => RecipeSerializer
end
