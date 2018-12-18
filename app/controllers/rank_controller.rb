class RankController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :init_product
  def create
    @rank_by_user=current_user.ranks.find_by product_id: params[:product_id]
    return update if @rank_by_user.present?
    current_user.ranks.create product_id: params[:product_id],
      ranking: params[:star]

    respond_to do |format|
      format.js
    end
  end

  def update
    @rank_by_user.update_attribute :ranking, params[:star]

    respond_to do |format|
      format.js {render "create.js.erb"}
    end
  end

  # Reset Star after Closing Dialog
  def reset_star
    respond_to do |format|
      format.js {render "create.js.erb"}
    end
  end

  private

  def init_product
    @product = Product.find_by id: params[:product_id]
  end
end
