class Game < ApplicationRecord
  validates :id, presence: true,
                 uniqueness: true,
                 numericality: { only_integer: true }
  validates :name, presence: true

  has_and_belongs_to_many :platforms
  has_and_belongs_to_many :genres

  default_scope { order(:name) }
end
