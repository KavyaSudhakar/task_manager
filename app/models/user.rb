class User < ApplicationRecord
    has_secure_password
    has_many :tasks, dependent: :destroy
    validates :email, presence: true, uniqueness: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
    enum status: { inactive: 0, active: 1}
end
