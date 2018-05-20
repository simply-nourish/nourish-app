# measure factory
# /spec/factories/measures.rb

FactoryBot.define do
  factory :measure do
    name { Faker::Lorem.unique.word }
  end
end
