class RankController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :init_product
  def create
    @rank_by_user = current_user.ranks.find_by product_id: params[:product_id]

    # Update Rank if Product has ranked before
    return update if @rank_by_user.present?

    # Cretea New Rank for Product by Current_User
    current_user.ranks.create product_id: params[:product_id],
      ranking: params[:star].to_i

    # Updating Average Rank
    update_average_rank

    respond_to do |format|
      format.js
    end
  end

  def update
    if params[:star].to_i != @rank_by_user.ranking
      @product.total_star -= @rank_by_user.ranking
      @rank_by_user.update_attribute :ranking, params[:star].to_i

      # Updating Average Rank
      update_average_rank
    end

    respond_to do |format|
      format.js{render "create.js.erb"}
    end
  end

  # Reset Star after Closing Dialog
  def reset_star
    respond_to do |format|
      format.js{render "create.js.erb"}
    end
  end

  private

  def init_product
    @product = Product.find_by id: params[:product_id]
  end

  def update_average_rank
    @product.total_star += params[:star].to_i
    @product.average_rank = @product.total_star / @product.ranks.count
    @product.update_attributes total_star: @product.total_star,
      average_rank: @product.average_rank
  end
end
