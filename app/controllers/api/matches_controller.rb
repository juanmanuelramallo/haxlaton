module API
  class MatchesController < ApplicationController
    # @route POST /api/matches (api_matches)
    def create
      match_data_form = MatchDataForm.new(match_params: match_params)
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
        match_players_attributes: [
          :team_id,
          {
            elo_change_attributes: [:value]
          },
          {
            player_attributes: [:name]
          },
          {
            player_stat_attributes: [:goals, :assits, :own_goals]
          }
        ]
      )
    end
  end
end
