class AddUniqueIndexToOrders < ActiveRecord::Migration[8.0]
  def change
    add_index :orders, [ :user_id, :status ], unique: true, where: "status = 'pending'"
  end
end
