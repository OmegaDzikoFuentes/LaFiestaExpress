class CreateLoyaltyCards < ActiveRecord::Migration[8.0]
  def change
    create_table :loyalty_cards do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :punches_count, default: 0, null: false
      t.decimal :discount_amount, precision: 10, scale: 2, default: 8.00, null: false
      t.boolean :is_completed, default: false, null: false
      t.boolean :is_redeemed, default: false, null: false
      t.datetime :completed_at
      t.datetime :redeemed_at
      t.timestamps
    end

    add_index :loyalty_cards, [ :user_id, :is_completed ]
    add_index :loyalty_cards, [ :user_id, :is_redeemed ]
  end
end
