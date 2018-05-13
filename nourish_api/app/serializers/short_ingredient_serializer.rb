# app/serializers/short_ingredient_serializer.rb
# Short/abbreviated Ingredient model serializer

class ShortIngredientSerializer < ActiveModel::Serializer
  attributes :id, :name
end