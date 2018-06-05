class CreateIngredientShoppingLists < ActiveRecord::Migration[5.1]
  def change
    create_table :ingredient_shopping_lists do |t|
      t.references :ingredient, foreign_key: true
      t.references :shopping_list, foreign_key: true
      t.float :amount, :null => false
      t.boolean :purchased, :null => false, :default => false
      t.references :measure, foreign_key: true

      t.timestamps
    end

    add_index :ingredient_shopping_lists, [:shopping_list_id, :ingredient_id, :measure_id], \
    unique: true, :name => 'ingredient_shopping_lists_index'
  
  end
end
 