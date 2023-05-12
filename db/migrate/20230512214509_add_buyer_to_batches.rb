class AddBuyerToBatches < ActiveRecord::Migration[7.0]
  def change
    add_reference :batches, :buyer, foreign_key: { to_table: :users }
  end
end
