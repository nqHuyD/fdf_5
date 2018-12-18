class CreateCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.integer :type_food
      t.integer :status

      t.timestamps
    end
  end
end
