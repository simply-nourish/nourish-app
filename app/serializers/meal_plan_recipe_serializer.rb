class MealPlanRecipeSerializer < ActiveModel::Serializer
  attributes :id, :day, :meal
  has_one :recipe, :serializer => ShortIngredientSerializer
  has_one :meal_plan, :serializer => MealPlanSerializer
end
