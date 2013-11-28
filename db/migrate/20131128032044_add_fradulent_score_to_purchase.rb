class AddFradulentScoreToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :fradulent_score, :decimal
  end
end
