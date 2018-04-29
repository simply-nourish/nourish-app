# removing existing user model to set up fresh Devise for user auth
# not removing user_id references unless required :)
# https://medium.com/@limichelle21/ctrl-z-in-rails-5-undo-tables-models-and-controllers-bc012ca49d68
# https://stackoverflow.com/questions/15648268/what-is-the-best-way-to-drop-a-table-remove-a-model-in-rails-3

class DropUsers < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :recipes, :users
    drop_table(:users)
  end
end
