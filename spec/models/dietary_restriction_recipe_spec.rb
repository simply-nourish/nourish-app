require 'rails_helper'

RSpec.describe DietaryRestrictionRecipe, type: :model do
  it { is_expected.to belong_to :dietary_restriction }
  it { is_expected.to belong_to :recipe }

  describe 'uniqueness validations' do 
    let!(:test_user) { create(:user) }
    let!(:test_recipe) { create(:recipe, user: test_user) }
    let!(:test_restriction) { create(:dietary_restriction) }
    subject { DietaryRestrictionRecipe.new(recipe: test_recipe, dietary_restriction: test_restriction) }
    it { is_expected.to validate_uniqueness_of(:recipe_id).scoped_to(:dietary_restriction_id) }
  end 

  it { is_expected.to validate_uniqueness_of(:recipe_id).scoped_to(:dietary_restriction_id) }
end
