class AddSessionStartTimeToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :session_start_time, :datetime
  end
end
