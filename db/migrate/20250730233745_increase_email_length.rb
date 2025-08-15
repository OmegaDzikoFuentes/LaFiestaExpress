class IncreaseEmailLength < ActiveRecord::Migration[8.0]
  def change
    change_column :users, :email, :string, limit: 255, null: false
  end
end
