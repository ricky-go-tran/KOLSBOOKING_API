class AddGoogleEventId < ActiveRecord::Migration[7.0]
  def up
    add_column :tasks, :google_event_id, :string, null: false, default: "none"
  end

  def down
    remove_column :tasks, :google_event_id
  end
end
