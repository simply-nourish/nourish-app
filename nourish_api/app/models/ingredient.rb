class Ingredient < ApplicationRecord
  
  # ingredient has 1:m relationship with ingredient_category
  belongs_to :ingredient_category

  # must have a name
  validates_presence_of :name

end
