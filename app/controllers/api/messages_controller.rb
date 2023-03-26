module API
  class MessagesController < ApplicationController
    def create
      match = Match.find(params[:match_id])
      match_players_by_player = match.match_players.includes(:player).to_h do |match_player|
        [match_player.player.name, match_player]
      end

      messages = messages_params.map do |message|
        next unless match_players_by_player.keys.include?(message[:player_name])

        {
          match_player_id: match_players_by_player[message[:player_name]].id,
          body: message[:body],
          sent_at: Time.at(message[:epoch_ms].to_i / 1000)
        }
      end.compact

      if messages.empty?
        render json: { error: "No valid messages" }, status: :unprocessable_entity
      else
        result = Message.insert_all(messages)
        render json: { messages_created: result.rows.size }, status: :created
      end
    end

    private

    def messages_params
      params.permit(messages: [:player_name, :body, :epoch_ms]).require(:messages)
    end
  end
end
