class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :inventory
      t.text :description
      t.integer :price
      t.boolean :food, default: true
      t.integer :category, null: false, default: 0

      t.timestamps
    end
  end
end
