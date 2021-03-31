json.array! @albums do |album|
  json.extract! album, :id, :title, :release_date
end
