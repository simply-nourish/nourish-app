class IngredientCategory < ApplicationRecord
  # name must exist
  validates_presence_of :name

  # has-many ingredients (1 category : n ingredients), 
  # when category is deleted, dependent fields are nullified
  has_many :ingredients, dependent: :nullify

end
