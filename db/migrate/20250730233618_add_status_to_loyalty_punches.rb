class AddStatusToLoyaltyPunches < ActiveRecord::Migration[8.0]
  def change
    add_column :loyalty_punches, :status, :string, default: "pending", null: false
  end
end