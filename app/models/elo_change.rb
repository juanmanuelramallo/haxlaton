# == Schema Information
#
# Table name: elo_changes
#
#  id              :bigint           not null, primary key
#  value           :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  match_player_id :bigint
#
# Indexes
#
#  index_elo_changes_on_match_player_id  (match_player_id)
#
# Foreign Keys
#
#  fk_rails_...  (match_player_id => match_players.id)
#
class EloChange < ApplicationRecord
  belongs_to :match_player

  delegate :player, to: :match_player

  after_commit :update_player_elo, on: :create

  def update_player_elo
    player.update(elo: player.elo + value)
  end
end
