class AddFieldsToReceiptUploads < ActiveRecord::Migration[8.0]
  def change
    unless column_exists?(:receipt_uploads, :approved_at)
      add_column :receipt_uploads, :approved_at, :datetime
    end
    unless column_exists?(:receipt_uploads, :approved_by_id)
      add_column :receipt_uploads, :approved_by_id, :integer
      add_index :receipt_uploads, :approved_by_id
    end
    unless column_exists?(:receipt_uploads, :admin_notes)
      add_column :receipt_uploads, :admin_notes, :text
    end
  end
end
