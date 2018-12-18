module CartHelper
  def addcookie quantity, index = nil
    quantity = 1 if quantity.nil?
    if index.nil?
      cookie_index_id
      cookie_index_quantity quantity
    else
      valuequantity = cookies[@symquantity.to_sym].split(",")
      valuequantity[index] = quantity
      update_quantity_cookie @symquantity.to_sym, valuequantity.join(",") + ","
    end
  end

  def init_id_cookie id
    cookies.permanent.signed[id] = @product.id.to_s + ","
  end

  def init_quantity_cookie id, quantity
    cookies.permanent[id] = quantity.to_s + ","
  end

  def update_id_cookie id, val
    cookies.permanent.signed[id] = val
  end

  def update_quantity_cookie id, val
    cookies.permanent[id] = val
  end

  def cookie_index_id
    if cookies.signed[@symid.to_sym].nil?
      init_id_cookie @symid.to_sym
    else
      valuecookie = cookies.signed[@symid.to_sym] + @product.id.to_s + ","
      update_id_cookie @symid.to_sym, valuecookie
    end
  end

  def cookie_index_quantity quantity
    if cookies[@symquantity.to_sym].nil?
      init_quantity_cookie @symquantity.to_sym, quantity
    else
      valuequantity = cookies[@symquantity.to_sym] + quantity.to_s + ","
      update_quantity_cookie @symquantity.to_sym, valuequantity
    end
  end

  def updatecookie id, newval
    symquantity = "cartquantity_" + current_user.id.to_s
    valuequantity = cookies[symquantity.to_sym].split(",")
    valuequantity[id.to_i - 1] = newval
    update_quantity_cookie symquantity.to_sym, valuequantity.join(",") + ","
  end

  def destroycookie id
    symid = "cartno_" + current_user.id.to_s
    symquantity = "cartquantity_" + current_user.id.to_s

    init_data_for_destory symid, symquantity, id
    destroy_cookie_process symid, symquantity
  end

  def init_data_for_destory symid, symquantity, id
    @valuecookie = cookies.signed[symid.to_sym].split(",")
    @valuequantity = cookies[symquantity.to_sym].split(",")

    @valuecookie.delete_at(id.to_i - 1)
    @valuequantity.delete_at(id.to_i - 1)
  end

  def destroy_cookie_process symid, symquantity
    if @valuecookie.blank?
      cookies.delete symid.to_sym
      cookies.delete symquantity.to_sym
    else
      cookies.permanent.signed[symid.to_sym] = @valuecookie.join(",") + ","
      cookies.permanent[symquantity.to_sym] = @valuequantity.join(",") + ","
    end
  end

  def destroy_all_cart
    symid = "cartno_" + current_user.id.to_s
    symquantity = "cartquantity_" + current_user.id.to_s
    cookies.delete symid.to_sym
    cookies.delete symquantity.to_sym
  end

  include CartHelperExtension
end
