class CreateBannerPhotos < ActiveRecord::Migration[8.0]
  def change
    create_table :banner_photos do |t|
      t.string :image_url

      t.timestamps
    end
  end
end
