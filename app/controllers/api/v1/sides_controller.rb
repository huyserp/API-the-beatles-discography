class Api::V1::SidesController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User

  def create
    @album = Album.find(params[:album_id])
    @side = Side.new(side_params)
    @side.album = @album
    authorize @side
    if @side.save
      render 'api/v1/albums/show'
    else
      render_error
    end
  end

  def destroy
    @side = Side.find(params[:id])
    authorize @side
    @side.destroy
    head :no_content
  end

  private

  def side_params
    params.require(:side).permit(:name)
  end

  def render_error
    render json: { errors: @side.errors.full_messages },
           status: :unprocessable_entity
  end
end
