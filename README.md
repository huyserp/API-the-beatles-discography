Anyone can fetch and use all data.

Users can:

  add and update albums

  remove albums which they've added

  add and remove sides to the albums which they've added

  add and update tracks per side for albums they've added

  remove tracks which they've added

Information
This API is a RESTful web service to obtain basic album data of The Beatles studio albums.
  
  includes all tracks with respective track number and time length per album side

  JSON response

Usage
Send all data requests to:
https://beatles-discography.herokuapp.com/api/v1/albums/

For details on a specific album, include album id at end of URL
https://beatles-discography.herokuapp.com/api/v1/albums/37

-this will get you "Abby Road"

To add sides to your newly created album, make requests to (EXAMPLE):
http://localhost:3000/api/v1/albums/68/sides

To add tracks to their respective sides, make requests to (EXAMPLE):
http://localhost:3000/api/v1/albums/68/sides/145/tracks

-this will get you "A Hard Day's Night" / side 1
