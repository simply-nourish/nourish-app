class IngredientRecipe < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient
  belongs_to :measure
  validates_presence_of :amount
end
