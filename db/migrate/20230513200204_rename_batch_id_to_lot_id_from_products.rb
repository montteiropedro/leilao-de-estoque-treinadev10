class RenameBatchIdToLotIdFromProducts < ActiveRecord::Migration[7.0]
  def change
    rename_column :products, :batch_id, :lot_id
  end
end
