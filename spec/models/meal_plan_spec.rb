require 'rails_helper'

RSpec.describe MealPlan, type: :model do

  # name must exist, must be unique
  it { is_expected.to validate_presence_of :name }

  # describe m:n relationship between meal plans and recipes
  it { is_expected.to have_many(:meal_plan_recipes).dependent(:destroy) }
  it { is_expected.to have_many(:recipes).through(:meal_plan_recipes) }
  
  describe 'uniqueness validations' do
    let!(:test_user) { create(:user) }
    subject { MealPlan.new(user: test_user, name: 'My Plan') }
    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:name)}
  end

  # must belong to one user
  it { is_expected.to belong_to :user}

end
