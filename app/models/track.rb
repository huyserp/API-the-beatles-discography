class Track < ApplicationRecord
  belongs_to :side
  belongs_to :album

  validates :number, presence: true, uniqueness: true
  validates :title, presence: true
  validates :album_id, uniqueness: { scope: :title }
  validates :length, presence: true
end
