class User < ApplicationRecord
  has_secure_password

  # Ensure username and email are unique
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
end
