class Side < ApplicationRecord
  belongs_to :album
  has_many :tracks, dependent: :destroy

  validates :name, presence: true, inclusion: { in: ['side 1', 'side 2', 'side 3', 'side 4'] }
end
