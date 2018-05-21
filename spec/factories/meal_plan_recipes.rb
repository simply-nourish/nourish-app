# meal_plan_recipe spec
# spec/factories/meal_plan_recipe.rb

FactoryBot.define do
    factory :meal_plan_recipe do
      recipe_id nil
      meal_plan_id nil
      meal { MealPlanRecipe.meals.values.sample }
      day { MealPlanRecipe.days.values.sample }
    end
  end 
  