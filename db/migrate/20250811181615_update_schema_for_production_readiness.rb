class UpdateSchemaForProductionReadiness < ActiveRecord::Migration[8.0]
  def change
    # Add max_punches to loyalty_cards
    add_column :loyalty_cards, :max_punches, :integer, default: 10, null: false

    # Change string timestamps to datetime
    change_column :users, :reset_password_sent_at, :datetime
    change_column :loyalty_punches, :rejected_at, :datetime

    # Add indexes on status fields with if_not_exists
    add_index :orders, :status, if_not_exists: true
    add_index :receipt_uploads, :status, if_not_exists: true

    # Change floats to decimals (precision 10, scale 2 for money)
    change_column :menu_items, :price, :decimal, precision: 10, scale: 2, null: false
    change_column :customizations, :price_adjustment, :decimal, precision: 10, scale: 2
    change_column :order_item_customizations, :price_adjustment, :decimal, precision: 10, scale: 2
    change_column :order_items, :item_price, :decimal, precision: 10, scale: 2, null: false
    change_column :orders, :subtotal, :decimal, precision: 10, scale: 2, default: 0.0, null: false
    change_column :orders, :tax, :decimal, precision: 10, scale: 2, default: 0.0, null: false
    change_column :orders, :total_amount, :decimal, precision: 10, scale: 2, default: 0.0, null: false
    change_column :restaurant_infos, :tax_rate, :decimal, precision: 5, scale: 3, default: 0.075, null: false

    # Enforce unique indexes on users with if_not_exists
    add_index :users, :email, unique: true, if_not_exists: true
    add_index :users, :username, unique: true, if_not_exists: true
  end
end
