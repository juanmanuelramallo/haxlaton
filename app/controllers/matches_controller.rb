class MatchesController < ApplicationController
  def index
    @pagy, @matches = pagy(Match.all.order(created_at: :desc))
  end

  def show
    @match = Match.find(params[:id])
    @messages = @match.messages.includes(:player, :match).order(sent_at: :asc).limit(100)
  end
end
