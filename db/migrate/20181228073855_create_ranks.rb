class CreateRanks < ActiveRecord::Migration[5.1]
  def change
    create_table :ranks do |t|
      t.references :user, foreign_key: true
      t.references :product, foreign_key: true
      t.integer :ranking

      t.timestamps
    end
  end
end
