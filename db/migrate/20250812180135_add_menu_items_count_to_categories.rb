class AddMenuItemsCountToCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :menu_items_count, :integer, default: 0, null: false
    
    # Populate existing records
    Category.find_each do |category|
      Category.reset_counters(category.id, :menu_items)
    end
  end
end