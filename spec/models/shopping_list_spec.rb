require 'rails_helper'

RSpec.describe ShoppingList, type: :model do

  # name must exist
  it { is_expected.to validate_presence_of :name }

  describe 'uniqueness validations' do 
    let!(:test_user){ create(:user) }
    subject { ShoppingList.new(name: 'My Shopping List', user: test_user) }
    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:name) }
  end 
  
  # must belong to one user
  it { is_expected.to belong_to :user}

  # association with ingredients
  it { is_expected.to have_many(:ingredient_shopping_lists).dependent(:destroy) }
  it { is_expected.to have_many(:ingredients).through(:ingredient_shopping_lists) }

end
