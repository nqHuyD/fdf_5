class ProductController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :product_params, only: [:create, :update]
  before_action :total_init, only: [:index]
  before_action :load_filter, only: [:category, :filter, :range_price, :rank]

  def index; end

  def create
    @food_images = product_params[:food_images]
    if session[:category_product].blank? || @food_images.blank?
      return respond_to do |format|
        format.js{render "category_missing.js.erb"}
      end
    end
    @product = Product.new name: product_params[:name],
      inventory: product_params[:inventory],
      description: product_params[:description],
      price: product_params[:price]
    insert_data
  end

  def show
    @product = Product.find_by id: params[:id]
    render :show
  end

  # Filter By Category
  def category
    respond_to do |format|
      format.js
    end
  end

  # Filter By Sorting
  def filter
    respond_to do |format|
      format.js
    end
  end

  # Filter By Range Price
  def range_price
    respond_to do |format|
      format.js{render "category.js.erb"}
    end
  end

  # Filter By Pagination
  def pagination
    @category = params[:category]
    @current_page = params[:current_page].to_i
    @filter = params[:filter]
    @rank_filter = params[:rank].to_i
    @rank_filter = 0 if params[:rank].blank?

    init_params_price

    respond_to do |format|
      format.js{render "filter.js.erb"}
    end
  end

  # Filter By Ranking
  def rank
    respond_to do |format|
      format.js{render "category.js.erb"}
    end
  end

  private

  def product_params
    params.require(:product)
  end

  def total_init
    @current_page = 1
    @total = Product.where(active: true).count
    @pages = Product.count / Settings.food.record.pages + 1
    @init_page = Settings.food.page.init
    @rank_filter = 0

    # Init params min and max range for rowdata
    init_params_price
  end

  # Transaction Processing
  def transaction_processing
    respond_to do |format|
      format.js{render "errors_transaction.js.erb"}
    end
  end

  def load_filter
    # Loading Filter
    loading_filter

    # Init maxrang and minrange params
    init_params_price

    # Count Number of Pages Appearing in the Product Page

    categorycount = init_product_follow_category

    @total = calculate_product_number categorycount
    return @pages = 1 if categorycount == Settings.food.record.pages
    @pages = @total / Settings.food.record.pages + 1
  end

  # Transaction Insert DATA Product
  def insert_data
    ActiveRecord::Base.transaction do
      begin
        @product.save!
        # Product Image Recording
        product_params[:food_images].each do |image|
          @image = FoodImage.create product_id: @product.id, picture: image
          @image.save!
        end

        # Product Category Recording
        session[:category_product].each do |category|
          @category_product = ProductCategory.create product_id: @product.id,
            category_id: category
        end
      rescue StandardError
        return transaction_processing
      end
      flash[:success] = "Creating Product Successful"
      respond_to do |format|
        format.js{render js: "window.location.replace('/admin/product_data');"}
      end
    end
  end

  def init_product_follow_category
    return Product.all if @category.nil?
    Product.joins(:product_categorys).where("category_id IN
      (?)", @category.to_i)
  end

  def init_params_price
    params[:maxrange] = Product.maximum(:price) if params[:maxrange].blank?
    params[:minrange] = Product.minimum(:price) if params[:minrange].blank?
    swap_range
  end

  def swap_range
    a = params[:minrange].to_i
    b = params[:maxrange].to_i
    a, b = b, a if a > b
    params[:minrange] = a
    params[:maxrange] = b
  end

  def loading_filter
    # Category Loading
    @category = params[:category]
    @category = nil if @category.blank?

    # Sorting Loading
    @filter = params[:filter]
    @filter = nil if @filter.blank?

    # Pagination Loading
    @current_page = params[:current_page].to_i
    @current_page = 1 if @current_page.zero?

    # Ranking Loading
    @rank_filter = params[:rank].to_i
  end

  def calculate_product_number categorycount
    categorycount = categorycount.where(active: true)
    categorycount = categorycount.where("price >= :minrange and
      price <= :maxrange", minrange: params[:minrange],
      maxrange: params[:maxrange])
    return count_product_average_rank categorycount if @rank_filter != 0
    categorycount.count
  end

  # Count Product by Average Rank
  def count_product_average_rank category
    category = category.where("average_rank = :rank_filter",
      rank_filter: @rank_filter)
    category.count
  end
end
