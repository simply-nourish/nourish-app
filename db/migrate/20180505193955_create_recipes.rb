class CreateRecipes < ActiveRecord::Migration[5.1]
  def change
    create_table :recipes do |t|
      t.string :title
      t.references :user, foreign_key: true
      t.string :source
      t.text :summary
      t.text :instructions
      t.timestamps
    end
  end
end
