module CartHelperExtension
  def current_cart_length
    return 0 if current_user.nil?
    symid = "cartno_" + current_user.id.to_s
    return 0 if cookies.signed[symid.to_sym].nil?
    get_cart_total symid
  end

  def get_cart_total symid
    current_cart = cookies.signed[symid.to_sym].split(",")
    current_cart.length
  end

  def current_cart_total
    @totalcart = 0
    return 0 if current_user.nil?
    symquantity = "cartquantity_" + current_user.id.to_s
    symid = "cartno_" + current_user.id.to_s
    get_total_cart symid, symquantity if cookies.signed[symid.to_sym].present?
    @totalcart
  end

  def get_total_cart symid, symquantity
    quantityarray = cookies[symquantity.to_sym].split(",")
    categoryarray = cookies.signed[symid.to_sym].split(",")
    categoryarray.each.with_index do |category, index|
      product = Product.find_by(id: category)
      quantity = quantityarray[index].to_i
      @totalcart += product.price * quantity if product.present?
    end
  end

  def current_cart
    symid = "cartno_" + current_user.id.to_s
    categoryarray = nil
    if cookies.signed[symid.to_sym].present?
      return categoryarray = cookies.signed[symid.to_sym].split(",")
    end
    categoryarray
  end

  def current_quanity
    symquantity = "cartquantity_" + current_user.id.to_s
    quantityarray = nil
    if cookies[symquantity.to_sym].present?
      quantityarray = cookies[symquantity.to_sym].split(",")
    end
    quantityarray
  end

  def find_product id
    Product.find_by(id: id)
  end
end
