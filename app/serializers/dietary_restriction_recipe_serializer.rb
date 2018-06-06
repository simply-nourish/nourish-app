# app/models/serializers/ingredient_recipe_serializer
# IngredientRecipe model serializer

class DietaryRestrictionRecipeSerializer < ActiveModel::Serializer
  attributes :id, :recipe_id
  has_one :dietary_restriction
end
  