class User < ApplicationRecord
  has_secure_password
  validates :id,
            presence: true,
            uniqueness: true,
            numericality: { only_integer: true }
  validates :name, presence: true, uniqueness: true
end
