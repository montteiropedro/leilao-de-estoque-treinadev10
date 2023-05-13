class RenameBatchIdToLotIdFromBids < ActiveRecord::Migration[7.0]
  def change
    rename_column :bids, :batch_id, :lot_id
  end
end
