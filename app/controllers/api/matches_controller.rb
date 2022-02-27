module API
  class MatchesController < ApplicationController
    # @route POST /api/matches (api_matches)
    def create
      @match = Match.new(match_params)
      if @match.save
        render json: @match
      else
        render json: @match.errors, status: :unprocessable_entity
      end
    end

    private

    def match_params
      params.require(:match).permit(:recording)
    end
  end
end
