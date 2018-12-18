module ProductHelper
  def render_product_filter
    case @filter.to_i
      when Settings.food.filter.alphaaz
        if @category.present?
          @products = get_product.order(:name)
        else
          @products = Product.order(:name)
        end
      when Settings.food.filter.alphaza
        if @category.present?
          @products = get_product.order("name DESC")
        else
          @products = Product.order("name DESC")
        end
      when Settings.food.filter.pricelh
        if @category.present?
          @products = get_product.order(:price)
        else
          @products = Product.order(:price)
        end
      when Settings.food.filter.pricehl
        if @category.present?
          @products = get_product.order("price DESC")
        else
          @products = Product.order("price DESC")
        end
      else
        if @category.present?
          @products = get_product
        else
          @products = Product.all
      end
    end

    #Filter Product Range
    @products = @products.where("price >= :minrange and price <= :maxrange",
      {minrange: params[:minrange], maxrange: params[:maxrange]})

    #Filter Product Follow Rank
    if @rank_filter != 0
      @products = @products.where("average_rank = :rank_filter",
        {rank_filter: @rank_filter})
    end
  end

  def get_product
    Product.joins(:product_categorys).where("category_id IN (?)", @category)
  end
end

