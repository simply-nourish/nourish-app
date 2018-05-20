class CreateDietaryRestrictions < ActiveRecord::Migration[5.1]
  def change
    create_table :dietary_restrictions do |t|
      t.string :name, unique: true, :null => false
      t.timestamps
    end
  end
end
