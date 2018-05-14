class CreateIngredientRecipes < ActiveRecord::Migration[5.1]
  def change
    create_table :ingredient_recipes do |t|
      t.references :recipe, foreign_key: true
      t.references :ingredient, foreign_key: true
      t.references :measure, foreign_key: true
      t.float :amount
      t.timestamps
    end
  end
end
