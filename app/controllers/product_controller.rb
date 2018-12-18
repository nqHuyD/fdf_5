class ProductController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :total_init, only: [:index]
  before_action :load_filter, only: [:category, :filter, :range_price, :rank]

  def index; end

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
    @category = params[:category].downcase.gsub(/\s+/, "")
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

  def total_init
    @current_page = 1
    @total = Product.count
    @pages = Product.count / Settings.food.record.pages
    @init_page =Settings.food.page.init
    @rank_filter = 0

    #Init params min and max range for rowdata
    params[:maxrange] = Product.maximum(:price) if params[:maxrange].blank?
    params[:minrange] = Product.minimum(:price) if params[:minrange].blank?
  end

  def load_filter

    # Category Loading
    @category = params[:category].downcase.gsub(/\s+/, "")
    @category = nil if @category.blank?

    # Sorting Loading
    @filter = params[:filter]
    @filter = nil if @filter.blank?

    # Pagination Loading
    @current_page = params[:current_page].to_i
    @current_page = 1 if @current_page == 0

    # Ranking Loading
    @rank_filter = params[:rank].to_i
    @rank_filter = 0 if @rank_filter.blank?

    # Init maxrang and minrange params
    params[:maxrange] = Product.maximum(:price) if params[:maxrange].blank?
    params[:minrange] = Product.minimum(:price) if params[:minrange].blank?

    # Count Number of Pages Appearing in the Product Page
    if @category.present?
      categorycount = Product.where(category: @category)
    else
      categorycount = Product.all
    end

    categorycount = categorycount.where("price >= :minrange and
      price <= :maxrange", {minrange: params[:minrange],
      maxrange: params[:maxrange]})

    categorycount =  categorycount.where("average_rank = :rank_filter",
     {rank_filter: @rank_filter}).count

    @total = categorycount

    if categorycount == Settings.food.record.pages
      @pages = 1
    else
      @pages = categorycount / Settings.food.record.pages + 1
    end
  end
end
