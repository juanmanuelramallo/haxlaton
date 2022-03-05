# == Schema Information
#
# Table name: elo_changes
#
#  id         :bigint           not null, primary key
#  value      :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  match_id   :bigint           not null
#  player_id  :bigint           not null
#
# Indexes
#
#  index_elo_changes_on_match_id   (match_id)
#  index_elo_changes_on_player_id  (player_id)
#
# Foreign Keys
#
#  fk_rails_...  (match_id => matches.id)
#  fk_rails_...  (player_id => players.id)
#
class EloChange < ApplicationRecord
  belongs_to :match
  belongs_to :player

  after_commit :update_player_elo, on: :create

  def update_player_elo
    player.update(elo: player.elo + value)
  end
end
