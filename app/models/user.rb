class User < ApplicationRecord
  has_secure_password
  validates :name, presence: true, uniqueness: true

  has_many :ratings,   dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_one  :backlog,   dependent: :destroy

  after_create :create_backlog

  def favorited?(favoritable)
    favorites.exists?(favoritable: favoritable)
  end

  private

  def create_backlog
    build_backlog.save
  end
end
