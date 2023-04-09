module API
  class RoomsController < ApplicationController
    def update
      if @current_room.update(room_params)
        if @current_room.haxball_room_url_previously_changed? && @current_room.haxball_room_url.present?
          RoomNotification.with({room_id: @current_room.id}).deliver(@current_room.created_by)
          Player.where.not(slack_user_id: [nil, ""]).each do |player|
            RoomNotification.with({room_id: @current_room.id, channel: player.slack_user_id}).deliver(player)
          end
        end
        render json: { message: "Room updated successfully with #{@current_room.haxball_room_url}" }, status: :ok
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
