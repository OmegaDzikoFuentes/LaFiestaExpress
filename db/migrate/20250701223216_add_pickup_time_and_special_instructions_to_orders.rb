class AddPickupTimeAndSpecialInstructionsToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :pickup_time, :datetime
    add_column :orders, :special_instructions, :text
  end
end
