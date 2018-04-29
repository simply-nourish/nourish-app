# meal plan factory
# spec/factories/meal_plans.rb

FactoryBot.define do
  factory :meal_plan do
    name { Faker::Lorem.word }
    user_id nil
  end
end
