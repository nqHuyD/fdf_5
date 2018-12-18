class RemoveFieldFoodFromProducts < ActiveRecord::Migration[5.1]
  def change
    remove_column :products, :food, :boolean
  end
end
