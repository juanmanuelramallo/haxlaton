class MatchesController < ApplicationController
  def index
    @pagy, @matches = pagy(Match.all.order(created_at: :desc))
  end

  def show
    @match = Match.find(params[:id])
  end

  def destroy
    @match = Match.find(params[:id])
    @match.destroy
    redirect_to matches_path
  end
end
