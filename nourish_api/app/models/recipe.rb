class Recipe < ApplicationRecord
  belongs_to :user
  validates_presence_of :title, :instructions, :summary

  # if a recipe is deleted, remove associations with ingredients
  # but do not destroy ingredients themselves
  has_many :ingredient_recipes, dependent: :destroy
  has_many :ingredients, :through => :ingredient_recipes
  
  # allow Recipe model to create ingredient_recipes
  accepts_nested_attributes_for :ingredient_recipes

  # can have many dietary restrictions
  has_and_belongs_to_many :dietary_restrictions

end
