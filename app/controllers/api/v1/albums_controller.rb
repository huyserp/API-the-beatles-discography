class Api::V1::AlbumsController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User, except: [ :index, :show ]
  before_action :find_album, only: [ :show ]

  def index
    @albums = policy_scope(Album)
  end

  def show
    authorize @album
  end

  def create
    @album = Album.new(album_params)
    @album.user = current_user
    authorize @album
    if @album.save
      render :show
    else
      render_error
    end
  end

  private

  def find_album
    @album = Album.find(params[:id])
  end

  def album_params
    params.require(:album).permit(:title, :release_date)
  end

  def render_error
    render json: { errors: @album.errors.full_messages },
           status: :unprocessable_entity
  end
end
