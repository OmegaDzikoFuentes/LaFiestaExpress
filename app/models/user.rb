class User < ApplicationRecord
    has_many :orders, dependent: :destroy

    validates :first_name, :last_name, :username, :email, :password, presence: true
    validates :username, :email, uniqueness: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

    def admin?
        admin
      end
      
      # You might also want to add this for a more readable full name
      def full_name
        "#{first_name} #{last_name}"
      end
end
