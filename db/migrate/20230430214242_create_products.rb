class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :code, null: false
      t.string :name, null: false
      t.string :description
      t.integer :weight
      t.integer :width
      t.integer :height
      t.integer :depth
      t.references :category, null: false, foreign_key: true
      t.references :batch, foreign_key: true

      t.timestamps
    end

    add_index :products, :code, unique: true
  end
end
