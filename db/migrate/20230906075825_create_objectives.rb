class CreateObjectives < ActiveRecord::Migration[7.0]
  def up
    create_table :objectives do |t|
      t.string :type_object
      t.bigserial :object_id
      t.timestamps
    end
  end

  def down
    drop_table :objectives
  end
end
