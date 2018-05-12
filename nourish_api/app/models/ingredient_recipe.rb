class IngredientRecipe < ApplicationRecord
  belongs_to :recipe, inverse_of: :ingredient_recipes
  belongs_to :ingredient
  belongs_to :measure
  validates_presence_of :amount
end
