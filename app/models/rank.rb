class Rank < ApplicationRecord
  belongs_to :user, depend: :destroy
  belongs_to :product, depend: :destroy
end
