class CreateBussinesses < ActiveRecord::Migration[7.0]
  def change
    create_table :bussinesses do |t|
      t.string :type_profile, :null => false, :default => "personal"
      t.text :overview, :null => false, :default => "Welcome to our company profile! At XYZ Tech Solutions, we're not just about technology; we're about creating a better future. As a leading innovator in the field of Information Technology and Software, we've been driving progress and delivering exceptional technology solutions for over a decade."
      t.references :profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
