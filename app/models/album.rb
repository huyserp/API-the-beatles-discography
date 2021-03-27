class Album < ApplicationRecord
  belongs_to :user
  has_many :sides
  has_many :tracks
end
