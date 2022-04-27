module API
  class MatchesController < ApplicationController
    # @route POST /api/matches (api_matches)
    def create
      @match = Match.new(match_params)
      @match.match_players.each do |match_player|
        existing_player = Player.find_by(name: match_player.player.name)

        next unless existing_player.present?

        elo_change = match_player.elo_change
        match_player.player = existing_player
        match_player.elo_change = elo_change
      end

      # Reads the header of the HBR2 file to fetch the duration of the recording.
      # https://github.com/haxball/haxball-issues/wiki/Linking-to-replay-files#hbr2-binary-header
      duration_secs = (match_params[:recording].read.unpack("NNN").last / 60.0).round
      @match.duration_secs = duration_secs
      match_params[:recording].rewind

      if @match.save
        render json: @match.attributes.merge(match_url: match_url(@match)), status: :created
      else
        render json: @match.errors, status: :unprocessable_entity
      end
    end

    private

    def match_params
      params.require(:match).permit(
        :recording,
        :winner_team_id,
        match_players_attributes: [
          :team_id,
          {
            elo_change_attributes: [:value]
          },
          {
            player_attributes: [:name]
          },
          {
            player_stat_attributes: [:goals, :assists, :own_goals]
          }
        ]
      )
    end
  end
end
