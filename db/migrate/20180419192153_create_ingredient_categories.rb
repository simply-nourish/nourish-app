class CreateIngredientCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :ingredient_categories do |t|
      t.string :name, unique: true, :null => false
      t.timestamps
    end
  end
end
