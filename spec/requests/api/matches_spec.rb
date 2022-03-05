require "rails_helper"

RSpec.describe API::MatchesController, type: :request do
  describe "POST /api/matches" do
    subject { post api_matches_path, params: params }

    let(:params) do
      {
        match: {
          match_players_attributes: [
            {
              team_id: "red",
              elo_change: 25,
              player_attributes: {
                name: "El Bicho"
              }
            },
            {
              team_id: "blue",
              elo_change: 5,
              player_attributes: {
                name: "Kerry"
              }
            }
          ]
        }
      }
    end

    it "creates a match object" do
      expect(Match.count).to eq(0)
      expect(Player.count).to eq(0)

      subject

      expect(response).to have_http_status(:created)
      expect(Match.count).to eq(1)
      expect(Match.last.match_players.count).to eq(2)
      expect(Player.count).to eq(2)
    end

    it "creates elo changes" do
      expect(EloChange.count).to eq(0)

      subject

      expect(EloChange.count).to eq(2)
      expect(EloChange.all).to contain_exactly(
        have_attributes(value: 25),
        have_attributes(value: 5)
      )
    end

    it "updates the players' elo" do
      subject

      expect(Player.all).to contain_exactly(
        have_attributes(name: "El Bicho", elo: 1525),
        have_attributes(name: "Kerry", elo: 1505)
      )
    end

    context "when a player already exists" do
      let!(:player) { create(:player, name: "El Bicho", elo: 1200) }

      it "does not create a new player object for El Bicho" do
        expect(Match.count).to eq(0)
        expect(Player.count).to eq(1)

        subject

        expect(response).to have_http_status(:created)
        expect(Match.count).to eq(1)
        expect(Match.last.match_players.count).to eq(2)
        expect(Player.count).to eq(2)
        expect(Player.where(name: "El Bicho").count).to eq(1)
      end

      it "creates elo changes for both players" do
        expect(EloChange.count).to eq(0)

        subject

        expect(EloChange.count).to eq(2)
        expect(EloChange.all).to contain_exactly(
          have_attributes(value: 25),
          have_attributes(value: 5)
        )
      end

      it "updates the players' elo" do
        subject

        expect(Player.all).to contain_exactly(
          have_attributes(name: "El Bicho", elo: 1225),
          have_attributes(name: "Kerry", elo: 1505)
        )
      end
    end
  end
end
