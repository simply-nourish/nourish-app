class IngredientShoppingList < ApplicationRecord
 
  # associations
  belongs_to :ingredient
  belongs_to :shopping_list, inverse_of: :ingredient_shopping_lists
  belongs_to :measure

  # ingredient, measure cannot be changed after creation
  attr_readonly :shopping_list_id
  attr_readonly :ingredient_id
  attr_readonly :measure_id

  # amount must exist
  validates_presence_of :amount

  # purchased flag must exist
  #validates_inclusion_of :purchased, :in => [true, false]

  # ingredient id + shopping list id combination must be unique
  validates_uniqueness_of :measure_id, :scope => [:shopping_list_id, :ingredient_id]

end
