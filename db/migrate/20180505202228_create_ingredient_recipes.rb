class CreateIngredientRecipes < ActiveRecord::Migration[5.1]
  def change
    create_table :ingredient_recipes do |t|
      t.references :recipe, foreign_key: true
      t.references :ingredient, foreign_key: true
      t.references :measure, foreign_key: true
      t.float :amount, :null => false
      t.timestamps
    end

    add_index :ingredient_recipes, [:recipe_id, :ingredient_id, :measure_id], \
              unique: true, :name => 'ingredient_recipes_index'
  
  end
end
