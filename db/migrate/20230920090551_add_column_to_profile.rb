class AddColumnToProfile < ActiveRecord::Migration[7.0]
  def up
    add_column :profiles, :avatar_url, :string
    add_column :profiles, :uid, :string
    add_column :profiles, :provider, :string
  end

  def down
    remove_column :profiles, :avatar_url
    remove_column :profiles, :uid
    remove_column :profiles, :provider
  end
end
