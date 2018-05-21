# app/models/serializers/abbrev_recipe_serializer.rb
# Abbreviated Recipe serializer

class AbbrevRecipeSerializer < ActiveModel::Serializer
  attributes :id, :title
end
  