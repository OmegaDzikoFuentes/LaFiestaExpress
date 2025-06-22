class User < ApplicationRecord
   has_secure_password
 
   has_many :orders, dependent: :destroy
   has_many :loyalty_cards, dependent: :destroy
   has_many :loyalty_punches, through: :loyalty_cards
 
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
 
   def admin?
     admin
   end
 
   def full_name
     "#{first_name} #{last_name}".strip
   end
 
   def current_loyalty_card
     loyalty_cards.active.first || loyalty_cards.create!
   end
 
   def total_punches
     loyalty_punches.count
   end
 
   def completed_cards_count
     loyalty_cards.completed.count
   end
 
   def total_loyalty_savings
     loyalty_cards.where(is_redeemed: true).sum(:discount_amount)
   end
 end