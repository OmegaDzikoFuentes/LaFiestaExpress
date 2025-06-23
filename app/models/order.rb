class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :menu_items, through: :order_items
  has_many :loyalty_punches, dependent: :destroy

  validates :status, presence: true
  validates :order_date, presence: true
  validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Status constants
  STATUSES = %w[cart placed preparing ready completed cancelled].freeze
  
  validates :status, inclusion: { in: STATUSES }

  scope :completed, -> { where(status: 'completed') }
  scope :active, -> { where.not(status: ['completed', 'cancelled']) }

  def total_items
    order_items.sum(:quantity)
  end

  def calculate_totals
    self.subtotal = order_items.sum { |item| item.quantity * item.item_price }
    self.tax = subtotal * 0.08 # Assuming 8% tax rate
    self.total_amount = subtotal + tax
  end

  def can_add_loyalty_punch?
    status == 'completed' && loyalty_punches.empty?
  end
end