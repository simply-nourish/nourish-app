class Recipe < ApplicationRecord
  belongs_to :user
  validates_presence_of :title, :instructions, :summary

  # if a recipe is deleted, remove associations with ingredients
  # but do not destroy ingredients themselves
  has_many :ingredient_recipes, dependent: :destroy
  has_many :ingredients, :through => :ingredient_recipes
  
  # allow Recipe model to create ingredient_recipes
  accepts_nested_attributes_for :ingredient_recipes

  # allow Recipe model to create dietary_restrictions_recipes
  has_many :dietary_restriction_recipes, dependent: :destroy

  # allow Recipe model to create dietary_restrictions_recipes
  accepts_nested_attributes_for :dietary_restriction_recipes

end
