class User < ApplicationRecord
  has_secure_password
  validates :name, presence: true, uniqueness: true

  has_many :ratings,    dependent: :destroy
  has_many :game_ratings, -> { where(rateable_type: Game.name) }, class_name: Rating.name
  has_many :favorites,  dependent: :destroy
  has_many :lists
  has_one  :backlog,    dependent: :destroy

  after_create :create_backlog

  def favorited?(favoritable)
    favorites.exists?(favoritable: favoritable)
  end

  def favorite_games
    Game.joins(:favorites)
        .where(favorites: { user_id: id })
  end

  def highest_rated_games
    Game.joins(:ratings)
        .where(ratings: { value: Rating.where(rateable_type: Game.name).maximum(:value) })
        .where(ratings: { user_id: id })
  end

  def lowest_rated_games
    Game.joins(:ratings)
        .where(ratings: { value: Rating.where(rateable_type: Game.name).minimum(:value) })
        .where(ratings: { user_id: id })
  end

  private

  def create_backlog
    build_backlog.save
  end
end
