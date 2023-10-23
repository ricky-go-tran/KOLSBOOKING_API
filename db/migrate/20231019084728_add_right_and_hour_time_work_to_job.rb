class AddRightAndHourTimeWorkToJob < ActiveRecord::Migration[7.0]
  def up
    add_column :jobs, :benefits, :string, null: false, default: ""
    add_column :jobs, :time_work, :string, null: false, default: ""
  end

  def down
    remove_column :jobs, :benefits
    remove_column :jobs, :time_work
  end
end
