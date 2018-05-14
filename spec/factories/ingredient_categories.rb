# ingredient_category factory
# /spec/factories/ingredient_categories.rb

FactoryBot.define do
  factory :ingredient_category do
    name { Faker::Lorem.word }
  end
end