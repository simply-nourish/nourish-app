require 'rails_helper'

RSpec.describe MealPlanRecipe, type: :model do
    
  # must have an amount
    it { is_expected.to validate_presence_of :day }
    it { is_expected.to validate_presence_of :meal }

    # must map to an meal_plan 
    it { is_expected.to belong_to :meal_plan }
  
    # must map to a recipe 
    it { is_expected.to belong_to :recipe }
  
    describe 'uniqueness validations' do 
      let!(:test_user) { create(:user) }
      let!(:test_recipe) { create(:recipe, user: test_user) }
      let!(:test_meal_plan) { create(:meal_plan, user: test_user) }
  
      subject { create(:meal_plan_recipe, recipe_id: test_recipe.id, meal_plan_id: test_meal_plan.id ) }
   
      it { is_expected.to validate_uniqueness_of(:meal_plan_id).scoped_to(:recipe_id, :day, :meal) }
    end



end
