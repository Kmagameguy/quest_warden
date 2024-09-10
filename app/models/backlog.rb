class Backlog < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :games

  validates :user, presence: true
end
