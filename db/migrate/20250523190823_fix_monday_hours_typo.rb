class FixMondayHoursTypo < ActiveRecord::Migration[8.0]
  def change
    rename_column :restaurant_infos, :mondaay_hours, :monday_hours
  end
end
