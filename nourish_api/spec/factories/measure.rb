# measure factory
# /spec/factories/measure.rb

FactoryBot.define do
  factory :measure do
    name { Faker::Lorem.word }
  end
end
