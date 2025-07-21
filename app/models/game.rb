class Game < ApplicationRecord
  validates :id, presence: true,
                 uniqueness: true,
                 numericality: { only_integer: true }
  validates :name, presence: true

  has_and_belongs_to_many :backlogs
  has_and_belongs_to_many :platforms
  has_and_belongs_to_many :genres
  has_many :involved_companies, dependent: :destroy
  has_many :companies, through: :involved_companies

  has_many :developers, -> { merge(InvolvedCompany.developers) },
                             through: :involved_companies,
                             source: :company

  has_many :publishers, -> { merge(InvolvedCompany.publishers) },
                             through: :involved_companies,
                             source: :company

  has_many :ported_by,  -> { merge(InvolvedCompany.porting) },
                             through: :involved_companies,
                             source: :company

  has_many :supporting_companies, -> { merge(InvolvedCompany.supporting) },
                                       through: :involved_companies,
                                       source: :company

  has_many :ratings,   as: :rateable,    dependent: :destroy
  has_many :favorites, as: :favoritable, dependent: :destroy
  has_many :favorited_by, through: :favorites, source: :user
  has_many :list_games
  has_many :lists, through: :list_games

  default_scope { order(:name) }

  def first_release_date
    Time.at(read_attribute(:first_release_date)).in_time_zone.to_datetime if first_release_date_present?
  end

  def first_release_date_present?
    read_attribute(:first_release_date).present?
  end

  private

  # Protect this association from being called directly; it's really
  # only useful as a :through table for setting up the more friendly
  # developers/publishers/etc associations
  def involved_companies
    super
  end
end
