require 'rails_helper'

RSpec.describe DietaryRestrictionRecipe, type: :model do
  it { is_expected.to belong_to :dietary_restriction }
  it { is_expected.to belong_to :recipe }
end
