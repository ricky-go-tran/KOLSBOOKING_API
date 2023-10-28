class CreateIndustries < ActiveRecord::Migration[7.0]
  def up
    create_table :industries do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end

  def down
    drop_table :industries
  end
end
