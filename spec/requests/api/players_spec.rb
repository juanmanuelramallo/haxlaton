require "rails_helper"

RSpec.describe API::PlayersController do
  describe "POST /api/players/auth" do
    subject { post auth_api_players_path, params: params }

    let(:params) do
      {
        auth: {
          name: auth_name,
          password: auth_password
        }
      }
    end
    let(:password) { "password" }
    let(:auth_password) { password }
    let(:player_name) { "Player 1" }
    let(:auth_name) { player_name }
    let!(:player) { create(:player, name: player_name, password: password) }

    it "returns head ok" do
      subject
      expect(response).to have_http_status(:ok)
    end

    context "when password is incorrect" do
      let(:auth_password) { "incorrect" }

      it "returns head unauthorized" do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when player is not found" do
      let(:auth_name) { "Player 2" }

      it "returns head unauthorized" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
