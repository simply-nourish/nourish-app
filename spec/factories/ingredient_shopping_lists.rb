# ingredient_shopping_list spec
# spec/factories/ingredient_shopping_lists.rb

FactoryBot.define do
    factory :ingredient_shopping_list do
      ingredient_id nil
      shopping_list_id nil
      measure_id nil
      amount { Faker::Number.decimal(3) }
      purchased false
    end
  end 
  