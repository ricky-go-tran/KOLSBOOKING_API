class CreateEmojis < ActiveRecord::Migration[7.0]
  def up
    create_table :emojis do |t|
      t.string :status, null: false, type: 'like'
      t.references :emojiable, polymorphic: true, null: false
      t.references :profile, null: false, foreign_key: true

      t.timestamps
    end
  end

  def down
    drop_table :emojis
  end
end
