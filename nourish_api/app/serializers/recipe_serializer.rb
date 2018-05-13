# app/models/serializers/recipe_serializer.rb
# Recipe serializer

class RecipeSerializer < ActiveModel::Serializer
  attributes :id, :title, :summary, :instructions
  has_many :ingredient_recipes
  has_many :dietary_restrictions
  has_one :user, :serializer => AbbrevUserSerializer
end
