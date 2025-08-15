class AddAvailableToMenuItems < ActiveRecord::Migration[8.0]
  def change
    add_column :menu_items, :available, :boolean, default: true, null: false
  end
end
