class ProductController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :total_init, only: [:index]
  before_action :load_filter, only: [:category, :filter]

  def index; end

  def show
    @product = Product.find_by id: params[:id]
    render :show
  end

  def category
    respond_to do |format|
      format.js
    end
  end

  def filter
    respond_to do |format|
      format.js
    end
  end

  def pagination
    @category = params[:category].downcase.gsub(/\s+/, "")
    @current_page = params[:current_page].to_i
    @filter = params[:filter]
    respond_to do |format|
      format.js
    end
  end

  private

  def total_init
    @current_page = 1
    @total = Product.count
    @pages = Product.count / Settings.food.record.pages
    @init_page =Settings.food.page.init
  end

  def load_filter
    @category = params[:category].downcase.gsub(/\s+/, "")
    @filter = params[:filter]
    @current_page = params[:current_page].to_i

    categorycount = Product.where(category: @category).count
    @total = categorycount

    if categorycount == Settings.food.record.pages
      @pages = 1
    else
      @pages = categorycount / Settings.food.record.pages + 1
    end

    @category = nil if @category.blank?
    @filter = nil if @filter.blank?
    @current_page = 1 if @current_page == 0
  end
end
