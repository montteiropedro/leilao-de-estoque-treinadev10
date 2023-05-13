class RenameBatchesToLots < ActiveRecord::Migration[7.0]
  def change
    rename_table :batches, :lots
  end
end
