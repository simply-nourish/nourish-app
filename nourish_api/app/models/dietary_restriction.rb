class DietaryRestriction < ApplicationRecord

  # name must exist
  validates_presence_of :name

end
