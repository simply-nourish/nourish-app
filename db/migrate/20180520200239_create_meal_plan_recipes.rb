class CreateMealPlanRecipes < ActiveRecord::Migration[5.1]
  def change
    create_table :meal_plan_recipes do |t|
      t.references :recipe, foreign_key: true
      t.references :meal_plan, foreign_key: true
      t.integer :meal, default: 1
      t.integer :day, default: 1
      t.timestamps
    end

    add_index :meal_plan_recipes, [:recipe_id, :meal_plan_id, :meal, :day], \
               unique: true, :name => 'meal_plan_recipes_index'

  end
end
