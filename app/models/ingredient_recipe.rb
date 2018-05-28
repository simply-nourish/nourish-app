class IngredientRecipe < ApplicationRecord
  belongs_to :recipe, inverse_of: :ingredient_recipes
  belongs_to :ingredient
  belongs_to :measure
  validates_presence_of :amount

  # combination of recipe, ingredient, measure must be unique
  validates_uniqueness_of :recipe_id, :scope => [:ingredient_id]
  
end
