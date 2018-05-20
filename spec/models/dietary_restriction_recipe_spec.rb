require 'rails_helper'

RSpec.describe DietaryRestrictionRecipe, type: :model do
  it { is_expected.to belong_to :dietary_restriction }
  it { is_expected.to belong_to :recipe }

  it { is_expected.to validate_uniqueness_of(:recipe_id).scoped_to(:dietary_restriction_id) }
end
