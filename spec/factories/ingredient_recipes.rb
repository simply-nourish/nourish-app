# ingredient_recipe spec
# spec/factories/ingredient_recipe.rb

FactoryBot.define do
  factory :ingredient_recipe do
    ingredient_id nil
    recipe_id nil
    measure_id nil
    amount { Faker::Number.decimal(3) }
  end
end 
