class Ingredient < ApplicationRecord
  belongs_to :ingredient_category

  validates_presence_of :name

end
