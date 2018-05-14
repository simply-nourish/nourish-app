# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(email: 'user@example.com', 
            nickname: 'UOne', 
            first_name: 'User', 
            last_name: 'One', 
            password: "monkey67", 
            default_servings: 1)
User.create!(email: 'foo@bar.com', 
            nickname: 'UTwo', 
            first_name: 'User', 
            last_name: 'Two', 
            password: "gorilla68", 
            default_servings: 1)

IngredientCategory.create!(name: 'condiments')  
IngredientCategory.create!(name: 'meat')      

Ingredient.create!(name: 'salt', ingredient_category_id: 1)
Ingredient.create!(name: 'flounder', ingredient_category_id: 2)

Measure.create!(name: 'cup')
Measure.create!(name: 'lb')

Recipe.create!(title: 'fishsticks', summary: 'some good fishsticks', instructions: 'put them in the oven', user_id: 1)

IngredientRecipe.create!(ingredient_id: 1, measure_id: 1, recipe_id: 1, amount: 3.5)
IngredientRecipe.create!(ingredient_id: 2, measure_id: 2, recipe_id: 1, amount: 2)

DietaryRestriction.create!(name: 'vegan')
DietaryRestriction.create!(name: 'vegetarian')
