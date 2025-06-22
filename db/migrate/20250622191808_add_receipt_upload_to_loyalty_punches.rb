class AddReceiptUploadToLoyaltyPunches < ActiveRecord::Migration[8.0]
  def change
    add_reference :loyalty_punches, :receipt_upload, null: false, foreign_key: true
  end
end
