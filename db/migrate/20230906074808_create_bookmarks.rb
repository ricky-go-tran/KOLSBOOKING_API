class CreateBookmarks < ActiveRecord::Migration[7.0]
  def up
    create_table :bookmarks do |t|
      t.references :kol_profile, null: false, foreign_key: true
      t.references :job, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end

  def down
    drop_table :bookmarks
  end
end
