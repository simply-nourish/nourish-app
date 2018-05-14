# app/models/serializers/ingredient_recipe_serializer
# IngredientRecipe model serializer

class DietaryRestrictionRecipeSerializer < ActiveModel::Serializer
    attributes :id, :name

    def id
      object.dietary_restriction.id
    end

    def name
      object.dietary_restriction.name
    end 

end
  