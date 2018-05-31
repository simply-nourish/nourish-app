class AddServingsToRecipe < ActiveRecord::Migration[5.1]
  
  # guard model stub
  class MigrationRecipe < ActiveRecord::Base
    self.table_name = :recipes
  end
  
  def change
    add_column(:recipes, :servings, :integer, :null => false)

    MigrationRecipe.reset_column_information
    MigrationRecipe.find_each do |recipe|
      recipe.servings = 1
      recipe.save!
    end

  end
end
