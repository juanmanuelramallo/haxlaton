module API
  class PlayersController < ApplicationController
    def index
      render json: Player.all
    end

    def auth
      player = Player.find_by!(name: auth_params[:name])
      authenticated = player.authenticate(auth_params[:password])

      head(authenticated ? :ok : :unauthorized)
    end

    private

    def auth_params
      params.require(:auth).permit(:name, :password)
    end
  end
end
