# Ingredient model spec
# /spec/models/ingredient_spec.rb

require 'rails_helper'

RSpec.describe Ingredient, type: :model do

  # must have a name, must be unique
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of :name }

  # must belong to one category
  it { is_expected.to belong_to :ingredient_category }

end
