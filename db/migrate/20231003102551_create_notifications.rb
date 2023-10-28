class CreateNotifications < ActiveRecord::Migration[7.0]
  def up
    create_table :notifications do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.string :type_notice, null: false, default: "notification"
      t.boolean :is_read, default: false, null: false
      t.references :sender, null: false, foreign_key: {to_table: :profiles}
      t.references :receiver, null: false, foreign_key: {to_table: :profiles}
      t.timestamps
    end
  end

  def down
    drop_table :notifications
  end
end
