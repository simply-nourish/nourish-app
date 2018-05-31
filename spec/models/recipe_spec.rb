require 'rails_helper'

RSpec.describe Recipe, type: :model do
  # validation tests
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :summary }
  it { is_expected.to validate_presence_of :instructions }

  # range of servings is 1..32
  it { is_expected.to validate_inclusion_of(:servings).in_array( (1..32).to_a ) }

  # association tests
  it { is_expected.to belong_to :user }
  it { is_expected.to have_many(:ingredient_recipes).dependent(:destroy) }
  it { is_expected.to have_many(:ingredients).through(:ingredient_recipes) }
  it { is_expected.to have_many(:dietary_restriction_recipes).dependent(:destroy) }

  describe 'uniqueness validations' do 
    let!(:test_user) { create(:user) }
    subject { Recipe.new(user: test_user, title: 'Fishsticks', summary: 'Some good fishsticks', instructions: 'The best you\'ll find', servings: 1) }
    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:title) }
  end

end

