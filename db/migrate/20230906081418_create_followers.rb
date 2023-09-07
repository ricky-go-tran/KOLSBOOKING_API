class CreateFollowers < ActiveRecord::Migration[7.0]
  def up
    create_table :followers do |t|
      t.references :follower, null: false, foreign_key: {to_table: :profiles}
      t.references :followed, null: false, foreign_key: {to_table: :profiles}
      t.timestamps
    end
  end

  def down
    drop_table :follower
  end
end
