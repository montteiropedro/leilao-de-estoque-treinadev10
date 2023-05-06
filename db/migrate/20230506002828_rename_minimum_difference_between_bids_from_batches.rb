class RenameMinimumDifferenceBetweenBidsFromBatches < ActiveRecord::Migration[7.0]
  def change
    rename_column :batches, :minimum_difference_between_bids, :min_diff_between_bids_in_centavos
  end
end
