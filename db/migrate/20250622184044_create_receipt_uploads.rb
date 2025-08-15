class CreateReceiptUploads < ActiveRecord::Migration[8.0]
  def change
    create_table :receipt_uploads do |t|
      t.references :user, null: false, foreign_key: true
      t.references :loyalty_card, null: true, foreign_key: true
      t.string :status, default: 'pending', null: false
      t.text :admin_notes
      t.datetime :approved_at
      t.references :approved_by, null: true, foreign_key: { to_table: :users }
      t.decimal :receipt_total, precision: 10, scale: 2
      t.date :receipt_date

      t.timestamps
    end

    add_index :receipt_uploads, [ :user_id, :status ]
    add_index :receipt_uploads, :status
  end
end
