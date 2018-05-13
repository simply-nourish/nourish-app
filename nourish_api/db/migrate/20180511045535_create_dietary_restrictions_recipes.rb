class CreateDietaryRestrictionsRecipes < ActiveRecord::Migration[5.1]
  def change
    create_table :dietary_restrictions_recipes, id: false do |t|
      t.belongs_to :dietary_restriction, index: true
      t.belongs_to :recipe, index: true
    end
  end
end
