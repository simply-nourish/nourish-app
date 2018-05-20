class DietaryRestrictionRecipe < ApplicationRecord
    belongs_to :dietary_restriction
    belongs_to :recipe

    # dietary_restriction + recipe combination must be unique
    validates_uniqueness_of :recipe_id, :scope => :dietary_restriction_id
end
