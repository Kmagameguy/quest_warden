class Rating < ApplicationRecord
  VALID_VALUES = (0.5..5).step(0.5).to_a.freeze

  validates :value, inclusion: { in: VALID_VALUES }
  belongs_to :user
  belongs_to :rateable, polymorphic: true

  default_scope { order(value: :desc) }

  def game
    rateable if rateable_type == Game.name
  end
end
