require 'rails_helper'

RSpec.describe Measure, type: :model do
  
  # name must exist, must be unique
  it { is_expected.to validate_presence_of :name }

  describe 'uniqueness validations' do 
    subject { Measure.new(name: 'Cups') }
    it { is_expected.to validate_uniqueness_of :name }
  end 

end
