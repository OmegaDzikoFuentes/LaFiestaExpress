class User < ApplicationRecord
    has_many :orders, dependent: :destroy

    validates :first_name, :last_name, :username, :email, :password, presence: true
    validates :username, :email, uniqueness: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
