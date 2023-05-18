class CreateBlockedCpfs < ActiveRecord::Migration[7.0]
  def change
    create_table :blocked_cpfs do |t|
      t.string :cpf, null: false

      t.timestamps
    end

    add_index :blocked_cpfs, :cpf, unique: true
  end
end
