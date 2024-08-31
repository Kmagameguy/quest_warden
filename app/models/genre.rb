class Genre < ApplicationRecord
  validates :id, presence: true,
                 uniqueness: true,
                 numericality: { only_integer:  true }
  validates :name, presence: true

  has_and_belongs_to_many :games
end
