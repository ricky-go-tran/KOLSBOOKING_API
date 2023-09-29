class AddAboutMeToKol < ActiveRecord::Migration[7.0]
  def up
    add_column :kol_profiles, :about_me, :text, default: "About me default", null: false
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end

  def down
    remove_column :kol_profiles, :about_me
  end
end
