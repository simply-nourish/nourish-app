class CreateShoppingLists < ActiveRecord::Migration[5.1]
  def change
    create_table :shopping_lists do |t|
      t.string :name, :null => false
      t.references :user, foreign_key: true
      t.timestamps
    end

    add_index :shopping_lists, [:name, :user_id], unique: true

  end
end
