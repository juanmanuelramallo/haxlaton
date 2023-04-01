class RoomsController < ApplicationController
  before_action :authenticate_player!
  skip_forgery_protection only: :show

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

  def show
    @room = Room.find(params[:id])

    respond_to do |format|
      format.html
      format.js { render js: @room.haxball_client }
    end
  end

  private

  def room_params
    params.require(:room).permit(:room_name, :max_players, :password, :public)
  end
end
