# app/models/serializers/meal_plan_serializer.rb
# MealPlan model serializer

class MealPlanSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :meal_plan_recipes
  has_one :user, :serializer => AbbrevUserSerializer
end
