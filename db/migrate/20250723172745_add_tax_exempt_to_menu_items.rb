class AddTaxExemptToMenuItems < ActiveRecord::Migration[8.0]
  def change
    add_column :menu_items, :tax_exempt, :boolean, default: false, null: false
  end
end
