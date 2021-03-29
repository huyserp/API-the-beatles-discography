class Side < ApplicationRecord
  belongs_to :album
  has_many :tracks

  validates :name, presence: true, inclusion: { in: ['side 1', 'side 2', 'side 3', 'side 4'] }
end
