class CreateRecipes < ActiveRecord::Migration[5.1]
  def change
    create_table :recipes do |t|
      t.string :title, :null => false
      t.references :user, foreign_key: true
      t.string :source
      t.text :summary, :null => false
      t.text :instructions, :null => false
      t.timestamps
    end

    add_index :recipes, [:title, :user_id], unique: true

  end
end
