class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.string :name
      t.decimal :lat
      t.decimal :lng
      t.decimal :price

      t.timestamps
    end
  end
end
