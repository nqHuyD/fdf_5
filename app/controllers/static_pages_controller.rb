class StaticPagesController < ApplicationController
  before_action :load_product, only: :product
  def home; end

  def about; end

  def mail; end

  def product
    @pages = Product.count / Settings.food.record.pages
  end

  private

  def load_product
    @product = Product.all.recent
  end
end
