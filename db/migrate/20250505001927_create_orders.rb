class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      # Foreign Key to users table
      t.references :user, null: false, foreign_key: true

      #order details
      t.datetime :order_date, null: false
      t.string   :status,        limit: 25,  null: false
      t.string   :contact_name,  limit: 25
      t.string   :contact_phone, limit: 20
      t.string   :contact_email, limit: 120

      # Financial and prices
      t.float    :subtotal,      null: false, default: 0.0
      t.float    :tax,           null: false, default: 0.0
      t.float    :total_amount,  null: false, default: 0.0

      t.timestamps
    end
  end
end
