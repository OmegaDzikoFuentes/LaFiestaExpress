class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :first_name, limit: 25, null: false
      t.string :last_name,  limit: 25, null: false
      t.string :username,   limit: 25, null: false
      t.string :email,      limit: 25, null: false
      t.string :phone,      limit: 20
      t.string :password,   limit: 25, null: false

      t.timestamps
    end
  end
end
