class User < ApplicationRecord
    has_many :orders, dependent: :destroy

    has_secure_password

    validates :first_name, :last_name, :username, presence: true
    validates :username, uniqueness: true
    validates :email,
       presence: true,
       uniqueness: true,
       format: { with: URI::MailTo::EMAIL_REGEXP }

    validates :password,
       length: { minimum: 6 },
       allow_nil: true

    validates :phone,
       format: { with: /\A\d{10}\z/, message: "must be 10 digits" },
       allow_blank: true

    def admin?
        admin
      end
      
      # You might also want to add this for a more readable full name
      def full_name
        "#{first_name} #{last_name}".strip
      end
end
