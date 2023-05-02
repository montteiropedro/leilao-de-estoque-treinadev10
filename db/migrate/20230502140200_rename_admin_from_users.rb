class RenameAdminFromUsers < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :admin, :is_admin
  end
end
