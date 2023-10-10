class AddStripeCustomerIdToProfile < ActiveRecord::Migration[7.0]
  def up
    add_column :profiles, :stripe_id, :string, null: false, default: "none"
  end
  def down
    remove_column :profiles, :stripe_id
  end
end
