class CreateProfiles < ActiveRecord::Migration[7.0]
  def up
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :fullname, null: false
      t.date :birthday
      t.string :phone
      t.text :address
      t.string :status, default: "valid"

      t.timestamps
    end
  end

  def down
    drop_table :profiles
  end
end
