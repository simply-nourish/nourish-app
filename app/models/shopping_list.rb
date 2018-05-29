class ShoppingList < ApplicationRecord
  
  # must have a name
  validates_presence_of :name

  # shopping list has a 1:m relationship with user
  belongs_to :user

  # shopping list has a m:1 relationship with meal_plan
  belongs_to :meal_plan

  # meal plan association cannot be changed after creation
  attr_readonly :meal_plan_id

  has_many :ingredients, :through => :ingredient_shopping_lists
  has_many :ingredient_shopping_lists, dependent: :destroy

  # allow ShoppingList model to update ingredient_shopping_lists
  accepts_nested_attributes_for :ingredient_shopping_lists, allow_destroy: true

  # same user can't create two identically-named shopping lists
  validates_uniqueness_of :user_id, :scope => :name

end
