require 'rails_helper'

RSpec.describe MealPlan, type: :model do

  # name must exist
  it { is_expected.to validate_presence_of :name }
  
  # must belong to one user
  it { is_expected.to belong_to :user}

end
