class InvolvedCompany < ApplicationRecord
  belongs_to :game
  belongs_to :company

  validates :id,
            presence: true,
            uniqueness: true,
            numericality: { only_integer: true }

  validates :game, presence: true
  validates :company, presence: true

  scope :developers, -> { where(developer: true) }
  scope :publishers, -> { where(publisher: true) }
  scope :porting,    -> { where(porting: true) }
  scope :supporting, -> { where(supporting: true) }
end
