# app/models/serializers/recipe_serializer.rb
# Recipe serializer

class RecipeSerializer < ActiveModel::Serializer
  attributes :id, :title, :summary, :instructions, :servings
  has_many :ingredient_recipes
  has_many :dietary_restriction_recipes
  has_one :user, :serializer => AbbrevUserSerializer
end
