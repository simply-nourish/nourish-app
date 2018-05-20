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

end
