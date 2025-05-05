class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :categories do |t|
      t.string :name,       limit: 25,  null: false
      t.string :description,limit: 200
      t.string :image_url,  limit: 255

      t.timestamps
    end
  end
end
