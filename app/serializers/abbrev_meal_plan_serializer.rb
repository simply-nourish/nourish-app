# app/models/serializers/abbrev_meal_plan_serializer.rb
# Abbreviated Meal Plan serializer

class AbbrevMealPlanSerializer < ActiveModel::Serializer
  attributes :id, :name
end
