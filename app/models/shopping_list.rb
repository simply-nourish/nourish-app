class ShoppingList < ApplicationRecord
  
  # must have a name
  validates_presence_of :name

  # shopping list has a 1:m relationship with user
  belongs_to :user

  # shopping list has a m:1 relationship with meal_plan
  belongs_to :meal_plan

  has_many :ingredients, :through => :ingredient_shopping_lists
  has_many :ingredient_shopping_lists, dependent: :destroy

  # same user can't create two identically-named shopping lists
  validates_uniqueness_of :user_id, :scope => :name

end
