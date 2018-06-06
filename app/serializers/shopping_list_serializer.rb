# app/models/serializers/shopping_list_serializer.rb
# ShoppingList model serializer

class ShoppingListSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_one :meal_plan, :serializer => AbbrevMealPlanSerializer
  has_one :user, :serializer => AbbrevUserSerializer
  has_many :ingredient_shopping_lists
end
  