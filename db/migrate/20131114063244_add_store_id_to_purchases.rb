class AddStoreIdToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :store_id, :integer
  end
end
