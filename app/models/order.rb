class Order < ApplicationRecord
    belongs_to :user

    has_many :order_items, dependent: :destroy

    validates :order_date, :status, presence: true
    validates :subtotal, :tax, :total_amount, numericality: { greater_than_or_equal_to: 0 }

end
