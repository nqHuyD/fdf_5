class ProductController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :load_filter, only: [:category, :filter]

  def index; end

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

  def load_filter
    @category = params[:category].downcase.strip
    @filter = params[:filter]

    @category = nil if @category.blank?
    @filter = nil if @filter.blank?
  end
end
