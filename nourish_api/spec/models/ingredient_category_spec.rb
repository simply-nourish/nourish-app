require 'rails_helper'

RSpec.describe IngredientCategory, type: :model do

  # destroying a category should nullify the 'category' FK in ingredients
  it { should have_many(:ingredients).dependent(:nullify) }

  # name must exist
  it { should validate_presence_of(:name) }

end
