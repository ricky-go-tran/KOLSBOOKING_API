class CreateKolProfiles < ActiveRecord::Migration[7.0]
  def up
    create_table :kol_profiles do |t|
      t.string :tiktok_path
      t.string :youtube_path
      t.string :facebook_path
      t.string :instagram_path
      t.string :stripe_public_key
      t.string :stripe_private_key
      t.references :profile, null: false, foreign_key: true

      t.timestamps
    end
  end

  def down
    drop_table :kol_profiles
  end
end
