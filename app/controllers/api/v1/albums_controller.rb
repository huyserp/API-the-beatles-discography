class Api::V1::AlbumsController < Api::V1::BaseController
  before_action :find_album, only: [ :show ]

  def index
    @albums = policy_scope(Album)
  end

  def show
    authorize @album
  end

  private

  def find_album
    @album = Album.find(params[:id])
  end
end
