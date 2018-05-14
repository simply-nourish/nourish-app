class DietaryRestriction < ApplicationRecord

  # name must exist
  validates_presence_of :name
  
  # express relationship with join table
  # if restriction is created, nullify entry in join table
  has_many :dietary_restriction_recipes, dependent: :destroy

end
