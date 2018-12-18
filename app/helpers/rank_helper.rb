module RankHelper
  def check_rank product
    if user_signed_in?
      rank = current_user.ranks.find_by product_id: product.id
    end
    return @star = 1 if rank.nil?
    @star = rank.ranking
  end
end
