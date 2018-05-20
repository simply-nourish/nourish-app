class MealPlan < ApplicationRecord
  
  # must have a name, must be unique
  validates_presence_of :name
  validates_uniqueness_of :user_id, :scope => :name

  # meal plan has a 1:m relationship with user
  belongs_to :user

end
