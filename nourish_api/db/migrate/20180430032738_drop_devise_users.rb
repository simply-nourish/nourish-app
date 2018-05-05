class DropDeviseUsers < ActiveRecord::Migration[5.1]
  def change
    #remove_foreign_key :recipes, :users
    remove_foreign_key "meal_plans", "users"
    remove_foreign_key "shopping_lists", "users"
    drop_table(:users)
  end
end
