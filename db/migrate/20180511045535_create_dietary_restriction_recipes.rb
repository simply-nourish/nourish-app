class CreateDietaryRestrictionRecipes < ActiveRecord::Migration[5.1]
  def change
    create_table :dietary_restriction_recipes do |t|
      t.belongs_to :dietary_restriction, index: true
      t.belongs_to :recipe, index: true
    end

    add_index :dietary_restriction_recipes, [:dietary_restriction_id, :recipe_id], \
               unique: true, :name => 'dietary_restriction_recipes_index'

  end
end
