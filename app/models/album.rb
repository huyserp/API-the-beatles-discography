class Album < ApplicationRecord
  belongs_to :user
  has_many :sides, dependent: :destroy
  has_many :tracks, dependent: :destroy

  validates :title, presence: true, uniqueness: true
  # must contain at lest the year relased (i.e. '.... 1964')
  validates :release_date, presence: true, format: { with: /\A.*\d{4}.*\z/ }
end
