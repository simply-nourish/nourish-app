# dietary_restriction factory
# /spec/factories/dietary_restrictions.rb

FactoryBot.define do
  factory :dietary_restriction do
    name { Faker::Lorem.word }
  end
end