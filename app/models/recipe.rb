class Recipe < ApplicationRecord
  belongs_to :user
  validates_presence_of :title, :instructions, :summary

  # if a recipe is deleted, remove associations with ingredients
  # but do not destroy ingredients themselves
  has_many :ingredient_recipes, dependent: :destroy
  has_many :ingredients, :through => :ingredient_recipes

  # validates that servings count is between 1 and 32
  validates :servings, :inclusion => { :in => 1..32 }
  
  # allow Recipe model to create ingredient_recipes
  accepts_nested_attributes_for :ingredient_recipes, allow_destroy: true

  # validates associated ingredient_recipes
  validates_associated :ingredient_recipes

  # validates associated dietary restrictions
  validates_associated :dietary_restriction_recipes

  # allow Recipe model to create dietary_restrictions_recipes
  has_many :dietary_restriction_recipes, dependent: :destroy
  has_many :dietary_restrictions, :through => :dietary_restriction_recipes

  # allow Recipe model to create dietary_restrictions_recipes
  accepts_nested_attributes_for :dietary_restriction_recipes, allow_destroy: true

  # user can't create multiple recipes with identical titles
  validates_uniqueness_of :user_id, :scope => :title

  # has many meal_plans
  has_many :meal_plan_recipes, dependent: :destroy
  has_many :meal_plans, through: :meal_plan_recipes

end
