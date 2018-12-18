module CartHelper
  def addcookie quantity = 1, index = nil
    if index.nil?
      if cookies[@symquantity.to_sym].nil?
        cookies.permanent[@symquantity.to_sym] = quantity.to_s + ','
      else
        valuequantity = cookies[@symquantity.to_sym] + quantity.to_s + ','
        cookies.permanent[@symquantity.to_sym] = valuequantity
      end

      if cookies.signed[@symid.to_sym].nil?
        cookies.permanent.signed[@symid.to_sym] = @product.id.to_s + ','
      else
        valuecookie = cookies.signed[@symid.to_sym] + @product.id.to_s + ','
        cookies.permanent.signed[@symid.to_sym] = valuecookie
      end
    else
      valuequantity = cookies[@symquantity.to_sym].split(",")
      valuequantity[index] = quantity
      cookies.permanent[@symquantity.to_sym] = valuequantity.join(",") + ','
    end
  end

  def updatecookie id, newVal
    symquantity = 'cartquantity_' + current_user.id.to_s
    valuequantity = cookies[symquantity.to_sym].split(",")
    valuequantity[id.to_i-1] = newVal

    cookies.permanent[symquantity.to_sym] = valuequantity.join(",") + ','
  end

  def destroycookie id
    symid = 'cartno_'+ current_user.id.to_s
    symquantity = 'cartquantity_' + current_user.id.to_s

    valuecookie = cookies.signed[symid.to_sym].split(",")
    valuequantity = cookies[symquantity.to_sym].split(",")

    valuecookie.delete_at(id.to_i - 1)
    valuequantity.delete_at(id.to_i - 1)

    if valuecookie.blank?
      cookies.delete symid.to_sym
      cookies.delete symquantity.to_sym
    else
      cookies.permanent.signed[symid.to_sym] = valuecookie.join(",") + ','
      cookies.permanent[symquantity.to_sym] = valuequantity.join(",") + ','
    end
  end

  def current_cart_length
    if current_user.present?
      symid = 'cartno_'+ current_user.id.to_s
      if cookies.signed[symid.to_sym].present?
        categoryarray = cookies.signed[symid.to_sym].split(",")
        return categoryarray.length
      end
    end
    return 0
  end

  def current_cart_total
    totalprice = 0
    if current_user.present?
      symquantity = 'cartquantity_' + current_user.id.to_s
      symid = 'cartno_'+ current_user.id.to_s
      if cookies.signed[symid.to_sym].present?
        quantityarray = cookies[symquantity.to_sym].split(",")
        categoryarray = cookies.signed[symid.to_sym].split(",")

        for i in 0..categoryarray.length-1
          product = Product.find_by(id: categoryarray[i])
          totalprice += product.price * quantityarray[i].to_i
        end
      end
    end
    return totalprice
  end

  def current_cart
    symid = 'cartno_'+ current_user.id.to_s
    categoryarray = nil
    if  cookies.signed[symid.to_sym].present?
      return categoryarray = cookies.signed[symid.to_sym].split(",")
    end
    return categoryarray
  end

  def current_quanity
    symquantity = 'cartquantity_' + current_user.id.to_s
    quantityarray = nil
    if cookies[symquantity.to_sym].present?
      quantityarray = cookies[symquantity.to_sym].split(",")
    end
    return quantityarray
  end

  def find_product id
    return product = Product.find_by(id: id)
  end
end
