class AddRequirementToJob < ActiveRecord::Migration[7.0]
  def up
    add_column :jobs, :requirement, :text, default: "Requirement content", null: false
  end

  def down
    remove_column :jobs, :requirement
  end
end
