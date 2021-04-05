class Api::V1::TracksController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User
  before_action :find_track, only: [ :update, :destroy ]

  def create
    @side = Side.find(params[:side_id])
    @album = @side.album
    @track = Track.new(track_params)
    @track.side = @side
    @track.album = @album
    authorize @track
    if @track.save
      render 'api/v1/albums/show'
    else
      render_error
    end
  end

  def update
    @album = @track.album
    if @track.update(track_params)
      render 'api/v1/albums/show'
    else
      render_error
    end
  end

  def destroy
    @track.destroy
    head :no_content
  end

  private

  def find_track
    @track = Track.find(params[:id])
    authorize @track
  end

  def track_params
    params.require(:track).permit(:number, :title, :length)
  end

  def render_error
    render json: { errors: @track.errors.full_messages },
           status: :unprocessable_entity
  end
end
