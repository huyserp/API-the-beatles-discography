class Track < ApplicationRecord
  belongs_to :side
  belongs_to :album
end
