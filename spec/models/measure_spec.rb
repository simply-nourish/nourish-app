require 'rails_helper'

RSpec.describe Measure, type: :model do
  
  # name must exist
  it { is_expected.to validate_presence_of :name }

end
