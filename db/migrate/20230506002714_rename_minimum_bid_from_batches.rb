class RenameMinimumBidFromBatches < ActiveRecord::Migration[7.0]
  def change
    rename_column :batches, :minimum_bid, :min_bid_in_centavos
  end
end
