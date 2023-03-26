require "rails_helper"

RSpec.describe API::MessagesController, type: :request do
  describe "POST /api/matches/:match_id/messages" do
    let(:match) { create(:match) }
    let(:match_player) { create(:match_player, match: match) }
    let(:other_match_player) { create(:match_player, match: match) }
    let(:messages) do
      [
        {
          player_name: match_player.player.name,
          body: "Disculpa nostra, no te queria insultar",
          epoch_ms: 1_600_000_000_000
        },
        {
          player_name: other_match_player.player.name,
          body: "oke oke",
          epoch_ms: 1_600_000_500_000
        }
      ]
    end

    before do
      match_player
      other_match_player
      subject
    end

    subject do
      post api_match_messages_path(match), params: { messages: messages }
    end

    it "creates two messages" do
      expect(Message.count).to eq(2)

      expect(Message.all).to contain_exactly(
        have_attributes(
          match_player_id: match_player.id,
          body: "Disculpa nostra, no te queria insultar",
          sent_at: be_an_instance_of(ActiveSupport::TimeWithZone)
        ),
        have_attributes(
          match_player_id: other_match_player.id,
          body: "oke oke",
          sent_at: be_an_instance_of(ActiveSupport::TimeWithZone)
        )
      )
    end

    it "returns the number of messages created" do
      expect(response.parsed_body["messages_created"]).to eq(2)
    end
  end
end
