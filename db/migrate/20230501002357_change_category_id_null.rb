class ChangeCategoryIdNull < ActiveRecord::Migration[7.0]
  def change
    change_column_null :products, :category_id, true
  end
end
