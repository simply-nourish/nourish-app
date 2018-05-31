# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user1 = User.create!(email: 'user@example.com', 
            nickname: 'UOne', 
            first_name: 'User', 
            last_name: 'One', 
            password: "monkey67", 
            default_servings: 1)
user2 = User.create!(email: 'foo@bar.com', 
            nickname: 'UTwo', 
            first_name: 'User', 
            last_name: 'Two', 
            password: "gorilla68", 
            default_servings: 1)

condiments = IngredientCategory.create!(name: 'condiments')  
meat = IngredientCategory.create!(name: 'meat')      
dairy = IngredientCategory.create!(name: 'dairy')   
vegetables = IngredientCategory.create!(name: 'vegetables')   
nuts = IngredientCategory.create!(name: 'nuts')   

salt = Ingredient.create!(name: 'salt', ingredient_category: condiments)
flounder = Ingredient.create!(name: 'flounder', ingredient_category: meat)
cheddar_cheese = Ingredient.create!(name: 'cheddar cheese', ingredient_category: dairy)
sweet_potato = Ingredient.create!(name: 'sweet potato', ingredient_category: vegetables)
turnip_greens = Ingredient.create!(name: 'turnip greens', ingredient_category: vegetables)
salted_peanuts = Ingredient.create!(name: 'salted peanuts', ingredient_category: nuts)

cup = Measure.create!(name: 'cup')
lb = Measure.create!(name: 'lb')

fishsticks = Recipe.create!(title: 'fishsticks', 
                            summary: 'some good fishsticks', 
                            instructions: 'put them in the oven', 
                            user: user1, 
                            servings: 1)

croque_monsieur = Recipe.create!(title: 'croque monsieur', 
                                 summary: 'a cheesy sandwich the whole family can enjoy', 
                                 instructions: 'order it at a restaurant', 
                                 user: user2, 
                                 servings: 2)

candied_yams = Recipe.create!(title: 'candied yams',
                              summary: 'a family treat, great with fishsticks', 
                              instructions: 'buy a yam, then candy it', 
                              user: user2, 
                              servings: 3)

pizza = Recipe.create!(title: 'pizza', 
                       summary: 'my fave-rave food', 
                       instructions: 'ditch the fishsticks, then call 1-800-NO-FSHTK', 
                       user: user2, 
                       servings: 4)

# fishsticks
IngredientRecipe.create!(ingredient: salt, measure: cup, recipe: fishsticks, amount: 3.5)
IngredientRecipe.create!(ingredient: flounder, measure: lb, recipe: fishsticks, amount: 2)

# croque monsieur
IngredientRecipe.create!(ingredient: cheddar_cheese, measure: lb, recipe: croque_monsieur, amount: 2.5)
IngredientRecipe.create!(ingredient: sweet_potato, measure: cup, recipe: croque_monsieur, amount: 5)

# candied yams
IngredientRecipe.create!(ingredient: sweet_potato, measure: cup, recipe: candied_yams, amount: 100)

# pizza
IngredientRecipe.create!(ingredient: cheddar_cheese, measure: lb, recipe: pizza, amount: 10.25)
IngredientRecipe.create!(ingredient: salted_peanuts, measure: cup, recipe: pizza, amount: 5)

# add dietary restrictions
vegan = DietaryRestriction.create!(name: 'vegan')
vegetarian = DietaryRestriction.create!(name: 'vegetarian')

# create a recipe with a dietary restriction
DietaryRestrictionRecipe.create(recipe: fishsticks, dietary_restriction: vegan)

# create a meal plan for User One
user_one_mp = MealPlan.create!(user: user1, name: 'Plan One')

# associate with recipes
MealPlanRecipe.create!(meal_plan: user_one_mp, recipe: fishsticks, day: "monday", meal: "snack")
MealPlanRecipe.create!(meal_plan: user_one_mp, recipe: croque_monsieur, day: "monday", meal: "breakfast")

