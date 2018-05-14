require 'rails_helper'

RSpec.describe IngredientRecipe, type: :model do

  # must have an amount
  it { is_expected.to validate_presence_of :amount }

  # must map to an ingredient 
  it { is_expected.to belong_to :ingredient }

  # must map to a recipe 
  it { is_expected.to belong_to :recipe }

  # must map to a unit of measure 
  it { is_expected.to belong_to :measure }

end
