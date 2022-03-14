module API
  class MatchesController < ApplicationController
    # @route POST /api/matches (api_matches)
    def create
      match_data_form = MatchDataForm.new(match_params: match_params, scoreboard_log_params: scoreboard_log_params)
      if match_data_form.save
        render json: match_data_form.data, status: :created
      else
        render json: match_data_form.errors, status: :unprocessable_entity
      end
    end

    private

    def match_params
      params.require(:match).permit(
        :recording,
        :scoreboard,
        match_players_attributes: [
          :team_id,
          {
            elo_change_attributes: [:value]
          },
          {
            player_attributes: [:name]
          }
        ]
      )
    end

    def scoreboard_log_params
      params.require(:scoreboard_log).permit(:data)
    end
  end
end
