module API
  class MessagesController < ApplicationController
    def create
      match = Match.find(params[:match_id])

      messages = messages_params.map do |message|
        player = Player.find_by(name: message[:player_name])
        next if player.nil?

        {
          match_id: match.id,
          player_id: player.id,
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
