class CreateMenuItems < ActiveRecord::Migration[8.0]
  def change
    create_table :menu_items do |t|
      t.string  :name,        limit: 100, null: false
      t.text    :description
      t.float   :price,       null: false
      t.string  :image_url,   limit: 255

      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
