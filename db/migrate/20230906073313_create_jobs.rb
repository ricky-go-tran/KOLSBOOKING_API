class CreateJobs < ActiveRecord::Migration[7.0]
  def up
    create_table :jobs do |t|
      t.references :profile, null: false, foreign_key: true
      t.bigserial :kol_id
      t.string :title, null: false
      t.text :description
      t.float :price, null: false
      t.string :status, null: false, default: 'post'
      t.string :stripe_id

      t.timestamps
    end
  end

  def down
    drop_table :jobs
  end
end
