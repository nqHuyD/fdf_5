class ProductCategory < ApplicationRecord
  belongs_to :product, dependent: :destroy
  belongs_to :category, dependent: :destroy
end
