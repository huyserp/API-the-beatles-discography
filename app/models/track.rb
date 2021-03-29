class Track < ApplicationRecord
  belongs_to :side
  belongs_to :album

  validates :number, presence: true
  validates :title, presence: true
  validates :album_id, uniqueness: { scope: :title }
  validates :side_id, uniqueness: { scope: :number }
  validates :length, presence: true
end
