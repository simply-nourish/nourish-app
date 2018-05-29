# Ingredient model spec
# /spec/models/ingredient_spec.rb

require 'rails_helper'

RSpec.describe Ingredient, type: :model do

  # must have a name, must be unique
  it { is_expected.to validate_presence_of :name }
  
  describe 'uniqueness validations' do 
    subject { Ingredient.new(name: 'Milk') }
    it { is_expected.to validate_uniqueness_of(:name) }
  end 

  # must belong to one category
  it { is_expected.to belong_to :ingredient_category }

  # association with recipes
  it { is_expected.to have_many(:ingredient_recipes).dependent(:nullify) }
  it { is_expected.to have_many(:recipes).through(:ingredient_recipes) }

  # association with shopping lists
  it { is_expected.to have_many(:ingredient_shopping_lists).dependent(:destroy) }
  it { is_expected.to have_many(:shopping_lists).through(:ingredient_shopping_lists) }

end
