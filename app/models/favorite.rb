class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :favoritable, polymorphic: true

  validates :user, presence: true
  validates :favoritable, presence: true
end
