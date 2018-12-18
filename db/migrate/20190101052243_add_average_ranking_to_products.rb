class AddAverageRankingToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :total_star, :integer, default: 0
    add_column :products, :average_rank, :integer, default: 0
  end
end
