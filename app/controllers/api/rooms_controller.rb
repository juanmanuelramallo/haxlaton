module API
  class RoomsController < ApplicationController
    def update
      if @current_room.update(room_params)
        render json: { message: "Updated successfully" }, status: :ok
      else
        render json: { errors: @current_room.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def room_params
      params.require(:room).permit(:haxball_room_url)
    end
  end
end
