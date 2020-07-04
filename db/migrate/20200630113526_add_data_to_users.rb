class AddDataToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :stripe_id, :string
    add_column :users, :stripe_subscription_id, :string
    add_column :users, :card_last4, :string
    add_column :users, :card_exp_month, :integer
    add_column :users, :card_exp_years, :integer
    add_column :users, :card_type, :string
    add_column :users, :admin, :boolean
    add_column :users, :subscribed, :boolean
  end
end
