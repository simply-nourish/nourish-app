require 'rails_helper'

RSpec.describe MealPlan, type: :model do

  # name must exist, must be unique
  it { is_expected.to validate_presence_of :name }
  
  describe 'uniqueness validations' do
    subject { MealPlan.new(name: 'My Plan') }
    it { is_expected.to validate_uniqueness_of :name }
  end

  # must belong to one user
  it { is_expected.to belong_to :user}

end
