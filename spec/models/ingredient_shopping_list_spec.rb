require 'rails_helper'

RSpec.describe IngredientShoppingList, type: :model do
  
    # must have an amount
    it { is_expected.to validate_presence_of :amount }

    # must map to an ingredient 
    it { is_expected.to belong_to :ingredient }
  
    # must map to a recipe 
    it { is_expected.to belong_to :shopping_list }
  
    # must map to a unit of measure 
    it { is_expected.to belong_to :measure }

    # enforce that combination of shopping_list_id, ingredient_id, and measure_id are all unique
    describe 'uniqueness validations' do 
    
      let!(:test_user) { create(:user) }
      let!(:test_category) { create(:ingredient_category) }
      let!(:test_ingredient) { create(:ingredient, ingredient_category: test_category) }
      let!(:test_meal_plan) { create(:meal_plan, user: test_user) }
      let!(:test_shopping_list) { create(:shopping_list, user: test_user, meal_plan: test_meal_plan) }
      let!(:test_measure) { create(:measure) }
  
      subject { create(:ingredient_shopping_list, ingredient_id: test_ingredient.id, shopping_list_id: test_shopping_list.id, measure_id: test_measure.id, amount: 1.5 ) }
   
      it { is_expected.to validate_uniqueness_of(:measure_id).scoped_to(:shopping_list_id, :ingredient_id) }
    
    end


end
