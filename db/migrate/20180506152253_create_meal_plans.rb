class CreateMealPlans < ActiveRecord::Migration[5.1]
  def change
    create_table :meal_plans do |t|
      t.references :user, foreign_key: true
      t.string :name, :null => false
      t.timestamps
    end

    add_index :meal_plans, [:name, :user_id], unique: true
  
  end
end
