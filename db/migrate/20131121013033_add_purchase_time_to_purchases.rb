class AddPurchaseTimeToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :purchase_time, :datetime
  end
end
