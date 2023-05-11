class RemoveValueInCentavosUniqueConstraintFromBids < ActiveRecord::Migration[7.0]
  def change
    remove_index :bids, :value_in_centavos
  end
end
