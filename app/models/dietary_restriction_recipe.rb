class DietaryRestrictionRecipe < ApplicationRecord
    belongs_to :dietary_restriction
    belongs_to :recipe
end
