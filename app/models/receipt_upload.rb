class ReceiptUpload < ApplicationRecord
  belongs_to :user
  belongs_to :loyalty_card
  belongs_to :approved_by, class_name: "User", optional: true
  has_one :loyalty_punch, dependent: :destroy
  has_one_attached :image

  validate :scan_image, if: :image_attached?
  validates :image, presence: true
  validate :acceptable_image
  validates :receipt_total, numericality: { greater_than: 0 }, allow_nil: true
  validates :status, inclusion: { in: %w[pending approved rejected] }

  scope :pending, -> { where(status: "pending") }
  scope :approved, -> { where(status: "approved") }
  scope :rejected, -> { where(status: "rejected") }

  def approved?
    status == "approved"
  end

  def rejected?
    status == "rejected"
  end

  def pending?
    status == "pending"
  end

  private

  def scan_image
    return unless Clamby.unsafe?(image.download)  # Download and scan
    errors.add(:image, "contains a virus")
  end

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