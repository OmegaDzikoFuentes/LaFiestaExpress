class OrderItemCustomization < ApplicationRecord
    belongs_to :order_item

    belongs_to :customization,  optional: true

    validates :customization_name, presence: true
    validates :price_adjustment, numericality: { allow_nil: true }
end
