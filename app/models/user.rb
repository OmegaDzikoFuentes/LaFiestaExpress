class User < ApplicationRecord
  has_secure_password
  encrypts :api_token, deterministic: true

  has_many :orders, dependent: :destroy
  has_many :loyalty_cards, dependent: :destroy
  has_many :loyalty_punches, through: :loyalty_cards
  has_many :receipt_uploads, dependent: :destroy

  validates :first_name, presence: true, length: { maximum: 25 }
  validates :last_name, presence: true, length: { maximum: 25 }
  validates :username, 
            presence: true, 
            uniqueness: true,
            length: { maximum: 25 }
  validates :email,
            presence: true,
            uniqueness: true,
            length: { maximum: 25 },
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password,
            length: { minimum: 6 },
            allow_nil: true
  validates :phone,
            length: { maximum: 20 },
            format: { with: /\A\d{10}\z/, message: "must be 10 digits" },
            allow_blank: true

  scope :admins, -> { where(admin: true) }
  scope :customers, -> { where(admin: false) }

  after_create :create_initial_loyalty_card, unless: :loyalty_cards_exists?

  # PUBLIC METHODS - These can be called from views, controllers, and other models
  
  def admin?
    admin
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def current_loyalty_card
    loyalty_cards.where(is_completed: false, is_redeemed: false).first ||
    loyalty_cards.where(is_completed: true, is_redeemed: false).first
  end


  def total_loyalty_savings
    loyalty_cards.where(is_redeemed: true).sum(:discount_amount)
  end

  def current_order
    orders.find_by(status: 'cart')
  end

  def generate_password_reset_token!
    self.reset_password_token = SecureRandom.urlsafe_base64
    self.reset_password_sent_at = Time.current
    save!(validate: false)
  end

  def password_reset_expired?
    reset_password_sent_at < 2.hours.ago
  end

  def total_punches
    loyalty_punches.count
  end

  def completed_cards_count
    loyalty_cards.where(is_completed: true).count
  end

  private

  # PRIVATE METHODS - These are only used internally within the User model
  
  def loyalty_cards_exists?
    loyalty_cards.any?
  end
  
  def create_initial_loyalty_card
    loyalty_cards.create!(
      punches_count: 0,
      discount_amount: 8.00
    )
  end
end