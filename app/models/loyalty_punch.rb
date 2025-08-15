class LoyaltyPunch < ApplicationRecord
    belongs_to :loyalty_card
    belongs_to :order
    belongs_to :receipt_upload, optional: true

    validates :punch_number, presence: true, numericality: { in: 1..10 }
    validates :order_id, uniqueness: { scope: :loyalty_card_id, message: "can only be punched once per card" }

    scope :recent, -> { order(created_at: :desc) }
    after_create :increment_punches_count
    after_destroy :decrement_punches_count

  private

  def increment_punches_count
    loyalty_card.increment!(:punches_count)
  end

  def decrement_punches_count
    loyalty_card.decrement!(:punches_count)
  end
end
