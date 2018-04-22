# ingredient factory
# spec/factories/ingredients.rb

FactoryBot.define do
  factory :ingredient do
    name { Faker::Lorem.word }
    ingredient_category_id nil
  end
end
