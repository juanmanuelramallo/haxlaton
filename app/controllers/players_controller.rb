class PlayersController < ApplicationController
  def index
    @players = Player.all
  end

  ###
  #
  # Chart data endpoints
  # These are used by chartkick to generate charts asynchronously
  #
  ###
  def elos_by_date
    players = Player.all.includes(:elo_changes).where(elo_changes: { created_at: from_date.beginning_of_day..to_date.end_of_day })

    data = players.map do |player|
      # Fetch latest elo for a player on a given date
      last_elos_by_date = player.elo_changes.group_by { |ec| ec.created_at.to_date }.map do |date, elos|
        [date, elos.sort_by(&:created_at).last.current_elo]
      end.to_h

      # Fill missing dates with the previous elo the player had. Empty if no elo changes.
      # This is to prevent the chart from showing a gap between the first and the next date a player had a match.
      (from_date..to_date).each do |date|
        last_elos_by_date[date] ||= last_elos_by_date[date - 1.day]
      end

      {
        name: player.name,
        data: last_elos_by_date
      }
    end

    render json: data
  end

  def from_date
    @from_date ||= Date.parse(params[:from_date] || 3.months.ago.to_s)
  end
  helper_method :from_date

  def to_date
    @to_date ||= Date.parse(params[:to_date] || Date.today.to_s)
  end
  helper_method :to_date
end
