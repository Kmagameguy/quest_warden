class User < ApplicationRecord
  has_secure_password
  validates :name, presence: true, uniqueness: true

  has_many :ratings
  has_one  :backlog, dependent: :destroy

  after_create :create_backlog

  private

  def create_backlog
    build_backlog.save
  end
end
