module ProductHelper
  def render_product_filter
    # Render Product
    init_render_product
    # Filter Product Active
    init_filter_product
  end

  def get_product
    Product.joins(:product_categorys).where("category_id IN (?)", @category)
  end

  def init_render_product
    case @filter.to_i
    when Settings.food.filter.alphaaz
      filter_case :name
    when Settings.food.filter.alphaza
      filter_case "name DESC"
    when Settings.food.filter.pricelh
      filter_case :price
    when Settings.food.filter.pricehl
      filter_case "price DESC"
    else
      filter_case
    end
  end

  def init_filter_product
    @products = @products.where("price >= :minrange and price <= :maxrange
      and active = true", minrange: params[:minrange],
      maxrange: params[:maxrange])
    product_filter_rank if @rank_filter != 0
  end

  def product_filter_rank
    @products = @products.where("average_rank = :rank_filter",
      rank_filter: @rank_filter)
  end

  def filter_case type = nil
    if type.present?
      return @products = get_product.order(type) if @category.present?
      @products = Product.order(type)
    else
      return @products = get_product if @category.present?
      @products = Product.all
    end
  end
end
