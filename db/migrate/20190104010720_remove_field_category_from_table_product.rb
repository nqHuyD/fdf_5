class RemoveFieldCategoryFromTableProduct < ActiveRecord::Migration[5.1]
  def change
    remove_column :products, :category, :integer
  end
end
