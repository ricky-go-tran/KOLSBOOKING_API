class AddStatusToUsers < ActiveRecord::Migration[7.0]
  def up
    add_column :users, :status, :string, null: false, default: "invalid"
  end

  def down
    remove_column :users, :status
  end
end
