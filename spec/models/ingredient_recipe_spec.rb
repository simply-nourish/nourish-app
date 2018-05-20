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

  describe 'uniqueness validations' do 
    let!(:test_user) { create(:user) }
    let!(:test_recipe) { create(:recipe, user: test_user) }
    let!(:test_ingredient_category) { create(:ingredient_category) }
    let!(:test_ingredient) { create(:ingredient, ingredient_category: test_ingredient_category) }
    let!(:test_measure) { create(:measure) }

    subject { IngredientRecipe.new(recipe: test_recipe, ingredient: test_ingredient, 
                                   amount: 1, measure: test_measure) }
 
    it { is_expected.to validate_uniqueness_of(:recipe_id).scoped_to(:ingredient_id, :measure_id) }
  end

end
