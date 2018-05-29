require 'rails_helper'

RSpec.describe User, type: :model do

  it { is_expected.to have_many :recipes }
  # validation tests
  it { is_expected.to validate_presence_of :first_name }
  it { is_expected.to validate_presence_of :last_name }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :encrypted_password }
  it { is_expected.to validate_presence_of :default_servings }

  # association tests
  it { is_expected.to have_many(:recipes).dependent(:destroy) }
  it { is_expected.to have_many(:meal_plans).dependent(:destroy) }
  it { is_expected.to have_many(:shopping_lists).dependent(:destroy) }
  
  describe 'uniqueness validations' do 
    subject { create(:user) }
    it { is_expected.to validate_uniqueness_of :nickname }
  end 

end
