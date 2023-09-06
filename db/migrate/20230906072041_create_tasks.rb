class CreateTasks < ActiveRecord::Migration[7.0]
  def up
    create_table :tasks do |t|
      t.references :kol_profile, null: false, foreign_key: true
      t.string :title, null: false
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.string :status, null: false, default: "planning"
      t.text :description

      t.timestamps
    end
  end

  def down
    drop_table :tasks
  end
end
