class CreateCustomizations < ActiveRecord::Migration[8.0]
  def change
    create_table :customizations do |t|
      t.references :menu_item, null: false, foreign_key: true

      t.string  :name,             limit: 100
      t.float   :price_adjustment
      t.boolean :is_default,       null: false, default: false

      t.timestamps
    end
  end
end
