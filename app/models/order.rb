class Order < ApplicationRecord
  belongs_to :user
  belongs_to :loyalty_card, optional: true
  has_many :order_items, dependent: :destroy
  has_many :menu_items, through: :order_items
  has_many :loyalty_punches, dependent: :destroy

  validates :status, presence: true
  validates :order_date, presence: true
  validate :total_amount_matches_calculation, on: :update

  # Status constants
  STATUSES = %w[cart placed preparing ready completed cancelled].freeze

  validates :status, inclusion: { in: STATUSES }

  scope :completed, -> { where(status: "completed") }
  scope :active, -> { where.not(status: [ "completed", "cancelled" ]) }

  def total_items
    order_items.sum(:quantity)
  end

  def calculate_totals
    self.order_items.includes(:order_item_customizations) if order_items.loaded?
    self.subtotal = order_items.sum do |item|
      next 0 if item.menu_item.tax_exempt
      item_total = item.quantity * item.item_price
      customization_total = item.order_item_customizations.sum { |c| c.price_adjustment || 0 }
      item_total + (customization_total * item.quantity)
    end
    self.tax = subtotal * (RestaurantInfo.first.tax_rate || 0.075)
    self.total_amount = subtotal + tax
    save!
  end

  def apply_loyalty_discount
    return unless loyalty_card&.can_be_redeemed?
    self.total_amount -= loyalty_card.discount_amount
    loyalty_card.redeem!
    save!
  end

  def can_add_loyalty_punch?
    status == "completed" && loyalty_punches.empty?
  end

  after_update :send_status_notification, if: :status_changed?
  private

  def total_amount_matches_calculation
    calculated_total = subtotal + tax
    errors.add(:total_amount, "must equal subtotal + tax") unless total_amount == calculated_total
  end
  def send_status_notification
    OrderMailer.status_update(self).deliver_later
  end
end
