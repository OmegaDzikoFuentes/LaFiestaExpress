class MenuItem < ApplicationRecord

    belongs_to :category, counter_cache: true

    has_many :customizations, dependent: :destroy

    has_many :order_items


    validates :name, :price, presence: true
    validates :price, numericality: { greater_than: 0 }
end
