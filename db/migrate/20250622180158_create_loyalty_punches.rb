class CreateLoyaltyPunches < ActiveRecord::Migration[8.0]
  def change
    create_table :loyalty_punches do |t|
      t.references :loyalty_card, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.integer :punch_number, null: false
      t.timestamps
    end

    add_index :loyalty_punches, [ :loyalty_card_id, :order_id ], unique: true
    add_index :loyalty_punches, :punch_number
  end
end
