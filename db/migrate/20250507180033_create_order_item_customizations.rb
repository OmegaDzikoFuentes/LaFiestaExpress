class CreateOrderItemCustomizations < ActiveRecord::Migration[8.0]
  def change
    create_table :order_item_customizations do |t|
      # foreign key back to order_items
      t.references :order_item, null: false, foreign_key: true

      # stores the name and price change of each customization
      t.string  :customization_name, limit: 100
      t.float   :price_adjustment

      t.timestamps
    end
  end
end
