require "rails_helper"

RSpec.describe API::MatchesController, type: :request do
  describe "POST /api/matches" do
    subject(:request) { post api_matches_path, params: params }

    let(:params) do
      {
        match: {
          match_players_attributes: [
            {
              team_id: "red",
              elo_change_attributes: {
                value: 25
              },
              player_attributes: {
                name: "El Bicho"
              }
            },
            {
              team_id: "blue",
              elo_change_attributes: {
                value: 5
              },
              player_attributes: {
                name: "Kerry"
              }
            }
          ]
        },
        scoreboard_log: {
          data: '{}'
        }
      }
    end

    let(:match_data_form) { instance_double(MatchDataForm, save: saved, data: nil, errors: nil) }

    before do
      allow(MatchDataForm).to receive(:new).and_return(match_data_form)
    end

    context 'when there are no errors' do
      let(:saved) { true }

      it 'uses the MatchDataForm' do
        request

        expect(match_data_form).to have_received(:save)
        expect(match_data_form).to have_received(:data)
        expect(match_data_form).not_to have_received(:errors)
      end

      it 'creates a match object' do
        request

        expect(response).to have_http_status(:created)
      end
    end

    context 'when there are errors' do
      let(:saved) { false }

      it 'uses the MatchDataForm' do
        request

        expect(match_data_form).to have_received(:save)
        expect(match_data_form).not_to have_received(:data)
        expect(match_data_form).to have_received(:errors)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
