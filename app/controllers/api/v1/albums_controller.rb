class Api::V1::AlbumsController < Api::V1::BaseController
  def index
    @albums = policy_scope(Album)
  end
end
