class ProductController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :total_init, only: [:index]
  before_action :load_filter, only: [:category, :filter]

  def index; end

  def show
    @product = Product.find_by id: params[:id]
    render :show
  end

  def product
    @pages = Product.count / Settings.food.record.pages
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

  private

  def total_init
    @total = Product.count
  end

  def load_filter
    @category = params[:category].downcase.gsub(/\s+/, "")
    @filter = params[:filter]
    @total = Product.where(category: @category).count

    @category = nil if @category.blank?
    @filter = nil if @filter.blank?
  end
end
