class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.text :address
      t.string :phone
      t.string :name
      t.integer :status
      t.integer :totalPrice
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
