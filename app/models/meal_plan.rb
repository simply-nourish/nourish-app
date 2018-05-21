class MealPlan < ApplicationRecord
  
  # must have a name, must be unique
  validates_presence_of :name
  validates_uniqueness_of :user_id, :scope => :name

  # meal plan has a 1:m relationship with user
  belongs_to :user

  # describe m:n relationship between meal plans and recipes
  has_many :meal_plan_recipes, dependent: :destroy
  has_many :recipes, :through => :meal_plan_recipes

  # allow meal_plan model to create meal_plan_recipes
  accepts_nested_attributes_for :meal_plan_recipes

end
