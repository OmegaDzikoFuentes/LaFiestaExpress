class AddLoyaltyCardToOrders < ActiveRecord::Migration[8.0]
  def change
    add_reference :orders, :loyalty_card, foreign_key: true, null: true
  end
end
