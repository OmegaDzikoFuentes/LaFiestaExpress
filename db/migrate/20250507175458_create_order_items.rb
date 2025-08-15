class CreateOrderItems < ActiveRecord::Migration[8.0]
  def change
    create_table :order_items do |t|
      t.references :order,     null: false, foreign_key: true
      t.references :menu_item, null: false, foreign_key: true

      t.integer :quantity,      null: false, default: 1
      t.float   :item_price,    null: false
      t.string  :item_name,     limit: 100, null: false
      t.string  :special_request, limit: 255


      t.timestamps
    end
  end
end
