class ProductOrder < ApplicationRecord
  belongs_to :order
  belongs_to :product
  has_many :categorys, primary_key: "product_id",
    foreign_key: "product_id", class_name: "ProductCategory"
end
