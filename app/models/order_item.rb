class OrderItem < ApplicationRecord

    belongs_to :order

    belongs_to :menu_item

    has_many :order_item_customizations, dependent: :destroy

    validates :quantity, presence: true, numericality: { greater_than: 0 }
    validates :item_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
