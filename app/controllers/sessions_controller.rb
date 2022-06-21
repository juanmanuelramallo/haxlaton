class SessionsController < ApplicationController
  class PlayerSession
    include ActiveModel::Model
    attr_accessor :name, :password

    validates :name, :password, presence: true

    def player
      @player ||= Player.find_by(name: name)
    end

    def logged_in?
      player.presence && player.authenticate(password)
    end
  end

  def new
    @session = PlayerSession.new
  end

  def create
    @session = PlayerSession.new(session_params)

    if @session.logged_in?
      session[:player_id] = @session.player.id
      redirect_to root_path, notice: "Todo oke oke"
    else
      flash.now[:alert] = "nope"
      @session.password = ""

      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:player_id] = nil
    redirect_to root_path, notice: "byebye"
  end

  private

  def session_params
    params.require(:session).permit(:name, :password)
  end
end
