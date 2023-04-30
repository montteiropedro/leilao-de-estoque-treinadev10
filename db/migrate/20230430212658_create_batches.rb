class CreateBatches < ActiveRecord::Migration[7.0]
  def change
    create_table :batches do |t|
      t.string :code, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.integer :minimum_bid, null: false
      t.integer :minimum_difference_between_bids, null: false
      t.references :creator, null: false
      t.references :approver

      t.timestamps
    end

    add_index :batches, :code, unique: true
    add_foreign_key :batches, :users, column: :creator_id, primary_key: :id
    add_foreign_key :batches, :users, column: :approver_id, primary_key: :id
  end
end
