# app/serializers/ingredient_serializer.rb
# ingredient model serializer

class IngredientSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_one :ingredient_category
end