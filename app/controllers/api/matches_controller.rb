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

      if @match.save
        @match.match_players.each do |match_player|
          EloChange.create(match: @match, player: match_player.player, value: match_player.elo_change.to_i)
        end

        render json: @match, status: :created
      else
        render json: @match.errors, status: :unprocessable_entity
      end
    end

    private

    def match_params
      params.require(:match).permit(
        :recording,
        match_players_attributes: [
          :team_id,
          :elo_change,
          {
            player_attributes: [:name]
          }
        ]
      )
    end
  end
end
