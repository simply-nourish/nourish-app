# meal_plan_recipe spec
# spec/factories/meal_plan_recipe.rb

FactoryBot.define do
    factory :meal_plan_recipe do
      recipe_id nil
      meal_plan_id nil
      meal { Faker::Number.between(0,3) }
      day { Faker::Number.between(0,6) }
    end
  end 
  