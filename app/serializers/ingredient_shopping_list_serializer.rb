# app/models/serializers/meal_plan_recipe_serializer.rb
# MealPlanRecipe model serializer

class IngredientShoppingListSerializer < ActiveModel::Serializer
    attributes :amount, :purchased
    has_one :ingredient
    has_one :measure, :serializer => MeasureSerializer
  end
  