# app/models/serializers/ingredient_recipe_serializer
# IngredientRecipe model serializer

class IngredientRecipeSerializer < ActiveModel::Serializer
  attributes :amount
  has_one :measure, :serializer => MeasureSerializer
  has_one :ingredient, :serializer => AbbrevIngredientSerializer
end
