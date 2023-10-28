class CreateGoogleIntegrates < ActiveRecord::Migration[7.0]
  def up
    create_table :google_integrates do |t|
      t.references :profile, null: false, foreign_key: true
      t.string :gmail
      t.string :refresh_token
      t.string :access_token
      t.string :code_authorization

      t.timestamps
    end
  end

  def down
    drop_table :google_integrates
  end
end
