class Company < ApplicationRecord
  validates  :id, presence: true,
                 uniqueness: true,
                 numericality: { only_integer: true }
  validates  :name, presence: true

  belongs_to :parent,
              class_name: Company.name,
              optional: true

  has_many   :companies,
              class_name: Company.name,
              foreign_key: :parent_id,
              dependent: :nullify

  has_many :involved_companies, dependent: :destroy
  has_many :games, through: :involved_companies

  has_many :developed_games, -> { merge(InvolvedCompany.developers) },
                                  through: :involved_companies,
                                  source: :game

  has_many :published_games, -> { merge(InvolvedCompany.publishers) },
                                  through: :involved_companies,
                                  source: :game

  has_many :ported_games,    -> { merge(InvolvedCompany.porting) },
                                  through: :involved_companies,
                                  source: :game

  has_many :game_contributions, -> { merge(InvolvedCompany.supporting) },
                                     through: :involved_companies,
                                     source: :game

  private

  # Protect this association from being called directly; similar to
  # the equivalent association in Game.rb, this is only really useful
  # as a :through table.
  def involved_companies
    super
  end
end
