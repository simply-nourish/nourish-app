class MealPlanSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :meal_plan_recipes
  has_one :user, :serializer => AbbrevUserSerializer
end
