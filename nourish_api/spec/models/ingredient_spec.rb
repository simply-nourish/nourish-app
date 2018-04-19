require 'rails_helper'

RSpec.describe Ingredient, type: :model do

  # must have a name
  it { should validate_presence_of(:name) }

  # must belong to one category
 # it { should belong_to(:ingredient_category) }

  #  pending "add some examples to (or delete) #{__FILE__}"

end
