class Ingredient < ApplicationRecord
  
  # ingredient has 1:m relationship with ingredient_category
  belongs_to :ingredient_category

  # ingredient has a m:m relationship with recipe
  has_many :ingredient_recipes, dependent: :nullify
  has_many :recipes, :through => :ingredient_recipes 

  # ingredient has a m:m relationship with shopping lists
  has_many :ingredient_shopping_lists, dependent: :destroy
  has_many :shopping_lists, :through => :ingredient_shopping_lists

  # must have a name
  validates_presence_of :name

  #name must be unique
  validates_uniqueness_of :name

end
