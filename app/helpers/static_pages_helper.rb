module StaticPagesHelper
  def render_data_product product
    @products = product
    pages = product.id / Settings.food.record.pages + 1
    if product.id % Settings.food.record.row == 0
      render partial: "layouts/product/record", locals: {product: product, pages: pages}
      render html: '
        <div class="clearfix"></div>
        </div>
        <div class="w3ls_dresses_grid_right_grid3">
      '.html_safe
    else
      render partial: "layouts/product/record", locals: {product: product, pages: pages}
    end
  end

  def render_image img
    image_tag(img.picture.url, alt: " ", class: "img-responsive" )
  end
end
