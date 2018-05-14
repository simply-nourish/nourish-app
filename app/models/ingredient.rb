class Ingredient < ApplicationRecord
  
  # ingredient has 1:m relationship with ingredient_category
  belongs_to :ingredient_category

  # ingredient has a m:m relationship with recipe
  has_many :ingredient_recipes, dependent: :nullify
  has_many :recipes, :through => :ingredient_recipes 

  # must have a name
  validates_presence_of :name

end
