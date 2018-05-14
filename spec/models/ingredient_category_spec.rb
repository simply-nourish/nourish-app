# IngredientCategory model spec
# /spec/models/ingredient_category_spec.rb

require 'rails_helper'

RSpec.describe IngredientCategory, type: :model do

  # destroying a category should nullify the 'category' FK in ingredients
  it { is_expected.to have_many(:ingredients).dependent(:nullify) }

  # name must exist
  it { is_expected.to validate_presence_of :name }

end
