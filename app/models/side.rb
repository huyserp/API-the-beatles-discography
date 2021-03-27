class Side < ApplicationRecord
  belongs_to :album
  has_many :tracks

  validates :name, presence: true, inclusion: { in: ['A side', 'B side'] }
end
