# app/serializers/ingredient_serializer.rb
# Ingredient model serializer

class IngredientSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_one :ingredient_category
end 