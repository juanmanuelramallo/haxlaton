class MatchesController < ApplicationController
  def index
    @pagy, @matches = pagy(Match.all.order(created_at: :desc))
  end

  def show
    @match = Match.find(params[:id])
    @messages = @match.messages.includes(match_player: :player).order(sent_at: :desc).limit(100)
  end
end
