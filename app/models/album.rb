class Album < ApplicationRecord
  belongs_to :user
  has_many :sides
  has_many :tracks

  validates :title, presence: true
  # must contain at lest the year relased (i.e. '.... 1964')
  validates :release_date, presence: true, format: { with: /\A.*\d{4}.*\z/ }
end
