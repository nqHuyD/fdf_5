class CreateFoodImages < ActiveRecord::Migration[5.1]
  def change
    create_table :food_images do |t|
      t.string :picture
      t.integer :is_primary
      t.references :product, foreign_key: true

      t.timestamps
    end
  end
end
