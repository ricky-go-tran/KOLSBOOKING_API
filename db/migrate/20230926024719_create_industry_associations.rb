class CreateIndustryAssociations < ActiveRecord::Migration[7.0]
  def change
    create_table :industry_associations do |t|
      t.references :industry, null: false, foreign_key: true
      t.references :insdustry_associationable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
