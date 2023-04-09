class RoomsController < ApplicationController
  before_action :authenticate_player!, except: :script
  skip_forgery_protection only: :script

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params.merge(created_by: current_player))

    if @room.save
      redirect_to @room
    else
      render :new
    end
  end

  def update
    @room = Room.find(params[:id])
    if @room.created_by != current_player
      redirect_to @room, alert: "No podes editar una sala que no creaste" and return
    end

    if @room.update(room_params)
      if @room.haxball_room_url_previously_changed? && @room.haxball_room_url.present?
        RoomNotification.with({room_id: @room.id}).deliver(current_player)
        Player.where.not(slack_user_id: nil).each do |player|
          RoomNotification.with({room_id: @room.id, channel: player.slack_user_id}).deliver(player)
        end
      end

      redirect_to @room
    else
      render :edit
    end
  end

  def show
    @room = Room.find(params[:id])

    if params[:redirect].present?
      redirect_to @room.haxball_room_url, allow_other_host: true
    end
  end

  def script
    @room = Room.find(params[:id])
    render js: @room.haxball_client
  end

  private

  def room_params
    params.require(:room).permit(:name, :max_players, :password, :public, :haxball_room_url)
  end
end
