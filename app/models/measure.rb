class Measure < ApplicationRecord
  
  # name must exist, must be unique
  validates_presence_of :name
  validates_uniqueness_of :name

end
