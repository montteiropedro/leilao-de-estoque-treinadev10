class CreateBids < ActiveRecord::Migration[7.0]
  def change
    create_table :bids do |t|
      t.integer :value, null: false
      t.references :user, null: false, foreign_key: true
      t.references :batch, null: false, foreign_key: true

      t.timestamps
    end

    add_index :bids, :value, unique: true
  end
end
