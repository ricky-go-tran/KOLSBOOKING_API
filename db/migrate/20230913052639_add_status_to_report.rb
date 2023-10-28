class AddStatusToReport < ActiveRecord::Migration[7.0]
  def up
    add_column :reports, :status, :string, default: 'pending'
  end

  def down
    remove_column :reports, :status
  end
end
