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
        format.js {render "category_missing.js.erb"}
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
      format.js {render "category.js.erb"}
    end
  end

  # Filter By Pagination
  def pagination
    @category = params[:category]
    @current_page = params[:current_page].to_i
    @filter = params[:filter]
    @rank_filter = params[:rank].to_i
    @rank_filter = 0 if params[:rank].blank?

    params[:maxrange] = Product.maximum(:price) if params[:maxrange].blank?
    params[:minrange] = Product.minimum(:price) if params[:minrange].blank?

    respond_to do |format|
      format.js {render "filter.js.erb"}
    end
  end

  # Filter By Ranking
  def rank
    respond_to do |format|
      format.js {render "category.js.erb"}
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
    @init_page =Settings.food.page.init
    @rank_filter = 0

    #Init params min and max range for rowdata
    params[:maxrange] = Product.maximum(:price) if params[:maxrange].blank?
    params[:minrange] = Product.minimum(:price) if params[:minrange].blank?
  end

  # Transaction Processing
  def transaction_processing
    respond_to do |format|
      format.js {render "errors_transaction.js.erb"}
    end
  end

  def load_filter

    # Category Loading
    @category = params[:category]
    @category = nil if @category.blank?

    # Sorting Loading
    @filter = params[:filter]
    @filter = nil if @filter.blank?

    # Pagination Loading
    @current_page = params[:current_page].to_i
    @current_page = 1 if @current_page == 0

    # Ranking Loading
    @rank_filter = params[:rank].to_i

    # Init maxrang and minrange params
    params[:maxrange] = Product.maximum(:price) if params[:maxrange].blank?
    params[:minrange] = Product.minimum(:price) if params[:minrange].blank?

    if params[:minrange].to_i > params[:maxrange].to_i
      params[:minrange], params[:maxrange] = params[:maxrange],
        params[:minrange]
    end

    # Count Number of Pages Appearing in the Product Page
    if @category.nil?
      categorycount = Product.all
    else
      categorycount = Product.joins(:product_categorys).where("category_id IN
        (?)", @category.to_i)
    end

    categorycount = categorycount.where(active: true)

    categorycount = categorycount.where("price >= :minrange and
      price <= :maxrange", {minrange: params[:minrange],
      maxrange: params[:maxrange]})

    if @rank_filter != 0
      categorycount =  categorycount.where("average_rank = :rank_filter",
       {rank_filter: @rank_filter}).count
    else
      categorycount = categorycount.count
    end

    @total = categorycount
    if categorycount == Settings.food.record.pages
      @pages = 1
    else
      @pages = categorycount / Settings.food.record.pages + 1
    end
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
      rescue
        return transaction_processing
      end
      flash[:success] = "Creating Product Successful"
      respond_to do |format|
        format.js{render :js => "window.location.replace('/admin/category_data');"}
      end
    end
  end
end
