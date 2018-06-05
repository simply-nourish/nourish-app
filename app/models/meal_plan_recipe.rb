class MealPlanRecipe < ApplicationRecord

    belongs_to :recipe
    belongs_to :meal_plan
    validates_presence_of :day, :meal

    enum day: [:monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday]
    enum meal: [:breakfast, :lunch, :dinner, :snack]
    
    # combination of meal_plan_id, day, meal must be unique
    validates_uniqueness_of :meal_plan_id, :scope => [:day, :meal]

end
