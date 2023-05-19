class CreateLotsUsersJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :lots, :users
  end
end
