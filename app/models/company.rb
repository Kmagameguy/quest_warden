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
end
