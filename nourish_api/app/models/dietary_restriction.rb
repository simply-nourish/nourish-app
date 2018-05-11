class DietaryRestriction < ApplicationRecord

  # name must exist
  validates_presence_of :name
  
  # can appear in many recipes
  has_and_belongs_to_many :recipes

end
