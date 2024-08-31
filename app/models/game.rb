class Game < ApplicationRecord
  validates :id, presence: true,
                 uniqueness: true,
                 numericality: { only_integer: true }
  validates :name, presence: true

  has_and_belongs_to_many :platforms
  has_and_belongs_to_many :genres

  default_scope { order(:name) }

  def first_release_date
    Time.at(read_attribute(:first_release_date)).in_time_zone.to_datetime if first_release_date_present?
  end

  def first_release_date_present?
    read_attribute(:first_release_date).present?
  end
end
