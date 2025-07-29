# app/models/loyalty_card.rb
class LoyaltyCard < ApplicationRecord
    belongs_to :user
    has_many :loyalty_punches, dependent: :destroy
    has_many :receipt_uploads, dependent: :nullify
    
    # Add missing scopes that User model references
    scope :active, -> { where(is_completed: false, is_redeemed: false) }
    scope :completed, -> { where(is_completed: true) }
    scope :redeemed, -> { where(is_redeemed: true) }
    
    validates :max_punches, presence: true, numericality: { greater_than: 0 }
    validates :user_id, :discount_amount, presence: true
  validates :punches_count, numericality: { greater_than_or_equal_to: 0 }

    
    def current_punches
      loyalty_punches.count
    end
    
    def punches_remaining
      max_punches - current_punches
    end

    def max_punches
      attributes['max_punches'] || 10
    end
    
    def completed?
      current_punches >= max_punches
    end
    
    def can_be_redeemed?
      completed? && !is_redeemed?
    end
    
    def redeem!
      return false unless can_be_redeemed?
      
      update!(
        is_completed: true,
        is_redeemed: true,
        redeemed_at: Time.current
      )
    end
    
    def progress_percentage
      return 100 if completed?
      (current_punches.to_f / max_punches * 100).round(1)
    end

    
  end


