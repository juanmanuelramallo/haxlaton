require 'rails_helper'

RSpec.describe MatchDataForm do
  let(:form) { described_class.new(match_params: match_params) }
  let(:match_params) {
    {
      match_players_attributes: [
        {
          team_id: "red",
          elo_change_attributes: {
            value: 25
          },
          player_attributes: {
            name: "El Bicho"
          },
          player_stat_attributes: {
            goals: 1,
            assists: 2,
            own_goals: 3,
          },
        },
        {
          team_id: "blue",
          elo_change_attributes: {
            value: 5
          },
          player_attributes: {
            name: "Kerry"
          },
          player_stat_attributes: {
            goals: 4,
            assists: 5,
            own_goals: 6,
          },
        },
      ]
    }
  }

  describe '#save' do
    subject(:save) { form.save }

    it 'creates match, players and match_players' do
      expect { save }.to change { Match.count }.by(1)
        .and change { Player.count }.by(2)

      expect(Match.last.match_players.count).to eq(2)
    end

    it 'creates player stats' do
      expect { save }.to change { PlayerStat.count }.by(2)

      bicho_player_stat = PlayerStat.first
      expect(bicho_player_stat.match_player.player.name).to eq('El Bicho')
      expect(bicho_player_stat.goals).to eq(1)
      expect(bicho_player_stat.assists).to eq(2)
      expect(bicho_player_stat.own_goals).to eq(3)

      kerry_player_stat = PlayerStat.second
      expect(kerry_player_stat.match_player.player.name).to eq('Kerry')
      expect(kerry_player_stat.goals).to eq(4)
      expect(kerry_player_stat.assists).to eq(5)
      expect(kerry_player_stat.own_goals).to eq(6)
    end

    it 'creates elo changes' do
      expect { save }.to change { EloChange.count }.by(2)
      expect(EloChange.all).to contain_exactly(
        have_attributes(value: 25),
        have_attributes(value: 5)
      )
    end

    it "updates the players' elo" do
      subject

      expect(Player.all).to contain_exactly(
        have_attributes(name: 'El Bicho', elo: 1525),
        have_attributes(name: 'Kerry', elo: 1505)
      )
      expect(EloChange.all).to contain_exactly(
        have_attributes(value: 25, current_elo: 1525),
        have_attributes(value: 5, current_elo: 1505)
      )
    end

    context "when a player already exists" do
      let!(:player) { create(:player, name: "El Bicho", elo: 1200) }

      it 'does not create a new player object for El Bicho' do
        expect { save }.to change { Match.count }.by(1)
          .and change { Player.count }.from(1).to(2)
          .and change { MatchPlayer.count }.by(2)

        expect(Player.where(name: "El Bicho").count).to eq(1)
      end

      it 'creates elo changes for both players' do
        expect { save }.to change { EloChange.count }.by(2)
        expect(EloChange.all).to contain_exactly(
          have_attributes(value: 25),
          have_attributes(value: 5),
        )
      end

      it "updates the players' elo" do
        save

        expect(Player.all).to contain_exactly(
          have_attributes(name: 'El Bicho', elo: 1225),
          have_attributes(name: 'Kerry', elo: 1505)
        )

        expect(EloChange.all).to contain_exactly(
          have_attributes(value: 25, current_elo: 1225),
          have_attributes(value: 5, current_elo: 1505)
        )
      end

      it 'creates player stats' do
        expect { save }.to change { PlayerStat.count }.by(2)

        bicho_player_stat = PlayerStat.first
        expect(bicho_player_stat.match_player.player.name).to eq('El Bicho')
        expect(bicho_player_stat.goals).to eq(1)
        expect(bicho_player_stat.assists).to eq(2)
        expect(bicho_player_stat.own_goals).to eq(3)

        kerry_player_stat = PlayerStat.second
        expect(kerry_player_stat.match_player.player.name).to eq('Kerry')
        expect(kerry_player_stat.goals).to eq(4)
        expect(kerry_player_stat.assists).to eq(5)
        expect(kerry_player_stat.own_goals).to eq(6)
      end
    end

    context 'when there is an error when saving the match' do
      before do
        match_params[:match_players_attributes][0][:team_id] = nil
      end

      it 'does not create a match' do
        expect { save }.not_to change { Match.count }
      end

      it 'does not create a player_stat' do
        expect { save }.not_to change { PlayerStat.count }
      end
    end
  end

  describe '#data' do
    subject(:data) { form.data }

    context 'when there are no errors after saving' do
      before do
        form.save
      end

      it 'returns data from the match created' do
        last_match = Match.last
        expect(data).to eq(
          last_match.attributes.merge(match_url: "http://test.yourhost.com/matches/#{last_match.id}")
        )
      end
    end
  end

  describe '#errors' do
    subject(:errors) { form.errors }

    context 'when there are no errors after saving' do
      before do
        form.save
      end

      it { expect(errors).to be_empty }
    end

    context 'when there are some errors after saving' do
      before do
        match_params[:match_players_attributes][0][:team_id] = nil

        form.save
      end

      it { expect(errors).to eq(["Match players team can't be blank"]) }
    end
  end
end
