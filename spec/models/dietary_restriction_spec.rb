require 'rails_helper'

RSpec.describe DietaryRestriction, type: :model do

  # name must exist
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to have_many(:dietary_restriction_recipes).dependent(:destroy) }

end
