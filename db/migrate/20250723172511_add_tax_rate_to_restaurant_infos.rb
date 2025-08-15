class AddTaxRateToRestaurantInfos < ActiveRecord::Migration[8.0]
  def change
    add_column :restaurant_infos, :tax_rate, :float, default: 0.075, null: false
  end
end