class CreateReports < ActiveRecord::Migration[7.0]
  def up
    create_table :reports do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.references :objective, null: false, foreign_key: true
      t.references :profile, null: false, foreign_key: true

      t.timestamps
    end
  end

  def down
    drop_table :reports
  end
end
