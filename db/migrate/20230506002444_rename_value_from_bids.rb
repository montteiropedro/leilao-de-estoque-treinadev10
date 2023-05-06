class RenameValueFromBids < ActiveRecord::Migration[7.0]
  def change
    rename_column :bids, :value, :value_in_centavos
  end
end
