class Track < ApplicationRecord
  belongs_to :side
  belongs_to :album

  validates :number, presence: true, uniqueness: true
  validates :title, presence: true, uniqueness: true
  validates :length, presence: true
end
