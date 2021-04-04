require 'open-uri'
require 'nokogiri'

User.destroy_all

puts "Removed all users, start fresh"

ringo = User.create!(email: 'ringo@beatles.com', password: '123456')
puts "Our user is #{ringo.email}"

################################################
##### Scrape for all beatles studio albums #####
################################################
discography_url = "https://en.wikipedia.org/wiki/The_Beatles_discography"
html_doc = Nokogiri::HTML(open(discography_url).read)

def scrape_album_titles(html_doc)
  html_album_titles = html_doc.search('th > i > a').map(&:text).slice(0..20)
  the_white_album = html_doc.search('th > a > i').first.parent.content
  html_album_titles.insert(-4, the_white_album)
  return html_album_titles
end

def scrape_release_dates(html_doc)
  html_release_dates = html_doc.search('td > ul > li').map(&:text).select { |element| element =~ /\AReleased: .*\z/ }
  html_release_dates = html_release_dates.slice(0..25)

  ### Removing dates if more than one release date (us v. uk)
  ### the shift in indecies has been considered after each delete
  html_release_dates.delete_at(8)
  html_release_dates.delete_at(12)
  html_release_dates.delete_at(13)
  html_release_dates.delete_at(15)

  html_release_dates.map! { |date| date.sub('Released: ', '') }
  html_release_dates[17] = "27 November 1967"
  return html_release_dates
end

album_titles = scrape_album_titles(html_doc)
album_release_dates = scrape_release_dates(html_doc)

# merge the title with its release date
album_data = album_titles.zip(album_release_dates)
album_data.delete_at(6)
album_data.delete_at(7)


# 'magical mystery tour' and 'the white album' each have 4 sides.
# must scrape songs differently
magical_white = []
2.times do
  magical_white << album_data.delete_at(15)
end

#####################################################
##### Scrape each album's songs and populate DB #####
#####################################################
def get_tracks_url(album)
  tracks_url = ''
  if album.first == 'Twist and Shout' || album.first == 'A Hard Day\'s Night' || album.first == 'Yellow Submarine'
    tracks_url = "https://en.wikipedia.org/wiki/#{album.first} (album)"
  elsif album.first == 'Something New' || album.first == 'Revolver' || album.first == 'Let It Be'
    tracks_url = "https://en.wikipedia.org/wiki/#{album.first} (Beatles album)"
  elsif album.first == 'The Beatles ("The White Album")'
    tracks_url = "https://en.wikipedia.org/wiki/The_Beatles_(album)"
  else
    tracks_url = "https://en.wikipedia.org/wiki/#{album.first}"
  end
  return tracks_url
end


album_data.each do |album|
  # 1. Create and save Album
  album_record = Album.new(title: album.first, release_date: album.last)
  album_record.user = ringo
  album_record.save!

  # 2. Scrape songs from album wikipedia page
  album_url = get_tracks_url(album)
  tracks_doc = Nokogiri::HTML(open(album_url.gsub(' ', '_')).read)
  # Each class '.tracklist' is a table in the DOM and one side of the album
  # (we only want the first 2 tables because these are only 2 sides to these albums)
  sides = []
  tracks_doc.search('.tracklist')[0..1].each do |element|
    # look at each table, and split it into its rows, then map each row to only its content.
    sides << element.search('tr').map { |child| child.text.strip }
  end

  sides.each_with_index do |side, index|
    # we dont care about the headers(first element) or total time(last element)
    side.pop
    side.shift
    # put the content of each side into a hash to pass to Active Record
    side.map! do |song|
      pattern = /^(?<number>\d+)."(?<title>.*)".*(?<length>\d+:\d+)$/
      song_data = song.match(pattern)
      Track.new(number: song_data[:number], title: song_data[:title], length: song_data[:length])
    end

    # 3. Create and save Sides based on index of elements in sides iteration
    album_side = Side.new(name: "side #{index + 1}")
    album_side.album = album_record
    album_side.save!

    # 4. Assign album and side to each track and save the track.
    side.each do |song|
      song.side = album_side
      song.album = album_record
      song.save!
    end
  end
  puts "------------------------------------------------------------------"
  puts "#{album_record.title} was created on #{album_record.release_date}."
  puts "It was added to the database by #{album_record.user.email}."
  puts "#{album_record.title} has #{album_record.tracks.count} songs on #{album_record.sides.count} different sides"
  album_record.sides.each do |side|
    puts "#{side.name} has the songs:"
    side.tracks.each { |track| puts "#{track.number}. #{track.title}" }
  end
  puts "------------------------------------------------------------------"
end

magical_white.each do |album|
  # 1. Create and save Album
  album_record = Album.new(title: album.first, release_date: album.last)
  album_record.user = ringo
  album_record.save!

  # 2. Scrape songs from album wikipedia page
  album_url = get_tracks_url(album)
  tracks_doc = Nokogiri::HTML(open(album_url.gsub(' ', '_')).read)
  # Each class '.tracklist' is a table in the DOM and one side of the album
  # (we only want the first 4 tables because these are the 4 sides
  # of the white album and magical mystery tour Double EP)
  sides = []
  tracks_doc.search('.tracklist')[0..3].each do |element|
    # look at each table, and split it into its rows, then map each row to only its content.
    sides << element.search('tr').map { |child| child.text.strip }
  end
  sides.each_with_index do |side, index|
    # we dont care about the headers(first element) or total time(last element)
    side.pop
    side.shift
    # put the content of each side into a hash to pass to Active Record
    side.map! do |song|
      pattern = /^(?<number>\d+)."(?<title>.*)".*(?<length>\d+:\d+)$/
      song_data = song.match(pattern)
      Track.new(number: song_data[:number], title: song_data[:title], length: song_data[:length])
    end

    # 3. Create and save Sides based on index of elements in sides iteration
    album_side = Side.new(name: "side #{index + 1}")
    album_side.album = album_record
    album_side.save!

    # 4. Assign album and side to each track and save the track.
    side.each do |song|
      song.side = album_side
      song.album = album_record
      song.save!
    end
  end
  puts "------------------------------------------------------------------"
  puts "#{album_record.title} was created on #{album_record.release_date}."
  puts "It was added to the database by #{album_record.user.email}."
  puts "#{album_record.title} has #{album_record.tracks.count} songs on #{album_record.sides.count} different sides"
  album_record.sides.each do |side|
    puts "#{side.name} has the songs:"
    side.tracks.each { |track| puts "#{track.number}. #{track.title}" }
  end
  puts "------------------------------------------------------------------"
end

