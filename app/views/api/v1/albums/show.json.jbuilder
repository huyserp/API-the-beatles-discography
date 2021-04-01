json.extract! @album, :id, :title, :release_date
json.sides @album.sides do |side|
  json.extract! side, :id, :name
  json.tracks side.tracks do |track|
    json.extract! track, :id, :number, :title, :length
  end
end
