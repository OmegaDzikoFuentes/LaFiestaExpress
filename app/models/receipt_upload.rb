# app/models/receipt_upload.rb
class ReceiptUpload < ApplicationRecord
    belongs_to :user
    has_one :loyalty_punch, dependent: :destroy
    
    # If using Active Storage for file uploads
    has_one_attached :image
    
    validates :image, presence: true
    validate :acceptable_image
    
    scope :pending_approval, -> { joins(:loyalty_punch).where(loyalty_punches: { is_approved: false }) }
    scope :approved, -> { joins(:loyalty_punch).where(loyalty_punches: { is_approved: true }) }
    scope :rejected, -> { joins(:loyalty_punch).where.not(loyalty_punches: { rejected_at: nil }) }
    
    def status
      return 'pending' unless loyalty_punch
      return 'rejected' if loyalty_punch.rejected_at.present?
      return 'approved' if loyalty_punch.is_approved?
      'pending'
    end
    
    def approved?
      loyalty_punch&.is_approved? == true
    end
    
    def rejected?
      loyalty_punch&.rejected_at.present?
    end
    
    def pending?
      loyalty_punch && !approved? && !rejected?
    end
    
    private
    
    def acceptable_image
      return unless image.attached?
      
      unless image.blob.byte_size <= 5.megabytes
        errors.add(:image, "is too big (should be at most 5MB)")
      end
      
      acceptable_types = ["image/jpeg", "image/jpg", "image/png", "image/gif"]
      unless acceptable_types.include?(image.blob.content_type)
        errors.add(:image, "must be a JPEG, PNG, or GIF")
      end
    end
  end