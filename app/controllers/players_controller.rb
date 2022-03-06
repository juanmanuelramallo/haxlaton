class PlayersController < ApplicationController
  def index
    # TODON'T: Don't LOWER(?) at home
    @players = Player.all.order("lower(name)")
  end
end
