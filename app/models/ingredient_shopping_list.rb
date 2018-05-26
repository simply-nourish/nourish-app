class IngredientShoppingList < ApplicationRecord
 
  # associations
  belongs_to :ingredient
  belongs_to :shopping_list
  belongs_to :measure

  # amount must exist
  validates_presence_of :amount

  # ingredient id + shopping list id combination must be unique
  validates_uniqueness_of :shopping_list_id, :scope => [:ingredient_id, :measure_id]

end
