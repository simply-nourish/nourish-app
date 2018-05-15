# app/models/serializers/ingredient_recipe_serializer
# IngredientRecipe model serializer

class IngredientRecipeSerializer < ActiveModel::Serializer
  attributes :amount, :measure
  has_one :ingredient, :serializer => ShortIngredientSerializer

end
