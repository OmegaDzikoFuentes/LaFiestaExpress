class Customization < ApplicationRecord

    belongs_to :menu_item

    has_many : order_item_customizations

    validates :name, presence: true
    validates :price_adjustment, numericality: { allow_nil: true }
end
