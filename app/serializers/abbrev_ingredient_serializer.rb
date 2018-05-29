# app/serializers/short_ingredient_serializer.rb
# Short/abbreviated Ingredient model serializer

class AbbrevIngredientSerializer < ActiveModel::Serializer
  attributes :id, :name
end