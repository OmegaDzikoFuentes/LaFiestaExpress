class CreateRestaurantInfos < ActiveRecord::Migration[8.0]
  def change
    create_table :restaurant_infos do |t|
      t.string :name, limit: 100
            t.string :street, limit: 100
            t.string :city, limit: 100
            t.string :state, limit: 100
            t.string :zip_code, limit: 20
            t.string :phone, limit: 20
            t.string :email, limit: 100
            t.string :logo_url, limit: 225
            t.string :mondaay_hours, limit: 50
            t.string :tuesday_hours, limit: 20
            t.string :wednesday_hours, limit: 20
            t.string :thursday_hours, limit: 20
            t.string :friday_hours, limit: 20
            t.string :saturday_hours
            t.string :sunday_hours
            t.timestamps
    end
  end
end
