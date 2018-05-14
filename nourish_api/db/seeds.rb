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
IngredientCategory.create!(name: 'dairy')   
IngredientCategory.create!(name: 'vegetables')   
IngredientCategory.create!(name: 'nuts')   

Ingredient.create!(name: 'salt', ingredient_category_id: 1)
Ingredient.create!(name: 'flounder', ingredient_category_id: 2)
Ingredient.create!(name: 'cheddar cheese', ingredient_category_id: 3)
Ingredient.create!(name: 'sweet potato', ingredient_category_id: 4)
Ingredient.create!(name: 'turnip greens', ingredient_category_id: 4)
Ingredient.create!(name: 'salted peanuts', ingredient_category_id: 5)

Measure.create!(name: 'cup')
Measure.create!(name: 'lb')

Recipe.create!(title: 'fishsticks', summary: 'some good fishsticks', instructions: 'put them in the oven', user_id: 1)
Recipe.create!(title: 'croque monsieur', summary: 'a cheesy sandwich the whole family can enjoy', instructions: 'order it at a restaurant', user_id: 2)
Recipe.create!(title: 'candied yams', summary: 'a family treat, great with fishsticks', instructions: 'buy a yam, then candy it', user_id: 2)
Recipe.create!(title: 'pizza', summary: 'my fave-rave food', instructions: 'ditch the fishsticks, then call 1-800-NO-FSHTK', user_id: 2)

# fishsticks
IngredientRecipe.create!(ingredient_id: 1, measure_id: 1, recipe_id: 1, amount: 3.5)
IngredientRecipe.create!(ingredient_id: 2, measure_id: 2, recipe_id: 1, amount: 2)

# croque monsieur
IngredientRecipe.create!(ingredient_id: 3, measure_id: 2, recipe_id: 2, amount: 2.5)
IngredientRecipe.create!(ingredient_id: 4, measure_id: 1, recipe_id: 2, amount: 5)

# candied yams
IngredientRecipe.create!(ingredient_id: 4, measure_id: 1, recipe_id: 3, amount: 100)

# pizza
IngredientRecipe.create!(ingredient_id: 3, measure_id: 2, recipe_id: 4, amount: 10.25)
IngredientRecipe.create!(ingredient_id: 6, measure_id: 1, recipe_id: 2, amount: 5)

# add dietary restrictions
DietaryRestriction.create!(name: 'vegan')
DietaryRestriction.create!(name: 'vegetarian')

# create a recipe with a dietary restriction
DietaryRestrictionRecipe.create(recipe_id: 1, dietary_restriction_id: 1)

