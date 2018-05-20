class ShoppingList < ApplicationRecord
  
  # must have a name
  validates_presence_of :name

  # shopping list has a 1:m relationship with user
  belongs_to :user

  # same user can't create two identically-named shopping lists
  validates_uniqueness_of :user_id, :scope => :name

end
