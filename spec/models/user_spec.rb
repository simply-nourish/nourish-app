require 'rails_helper'

RSpec.describe User, type: :model do
  # association tests

  it { is_expected.to have_many :recipes }
  # validation tests
  it { is_expected.to validate_presence_of :first_name }
  it { is_expected.to validate_presence_of :last_name }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :encrypted_password }
  it { is_expected.to validate_presence_of :default_servings }

  it { is_expected.to have_many(:recipes).dependent(:destroy) }
  
end
