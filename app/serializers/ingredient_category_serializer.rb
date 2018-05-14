# app/serializers/ingredient_category_serializer.rb
# IngredientCategory model serializer

class IngredientCategorySerializer < ActiveModel::Serializer
  attributes :id, :name
end
