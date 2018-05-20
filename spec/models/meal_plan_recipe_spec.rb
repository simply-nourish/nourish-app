require 'rails_helper'

RSpec.describe MealPlanRecipe, type: :model do

  # must have an amount
  it { is_expected.to validate_presence_of :day }
  it { is_expected.to validate_presence_of :meal }

  # must map to a recipe 
  it { is_expected.to belong_to :recipe }

   #must map to a meal plan 
  it { is_expected.to belong_to :meal_plan }

  describe 'uniqueness validations' do 
    let!(:test_user) { create(:user) }
    let!(:test_recipe) { create(:recipe, user: test_user) }
    let!(:test_meal_plan) { create(:meal_plan, user: test_user) }

    subject { MealPlanRecipe.new( recipe: test_recipe, meal_plan: test_meal_plan ) }
    it { is_expected.to validate_uniqueness_of(:meal_plan_id).scoped_to(:recipe_id, :day, :meal) }
  end 

end
