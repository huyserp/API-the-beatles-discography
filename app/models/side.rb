class Side < ApplicationRecord
  belongs_to :album

  validates :name, presence: true, inclusion: { in: ['A side', 'B side'] }
end
