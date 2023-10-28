class AddCategoryToTask < ActiveRecord::Migration[7.0]
  def up
    add_column :tasks, :category, :string, null: false, default: "personal"
  end

  def down
    remove_column :tasks, :category
  end
end
