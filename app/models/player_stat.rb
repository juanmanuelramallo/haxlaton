# == Schema Information
#
# Table name: player_stats
#
#  id              :bigint           not null, primary key
#  assists         :integer
#  goals           :integer
#  own_goals       :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  match_player_id :bigint
#
# Indexes
#
#  index_player_stats_on_match_player_id  (match_player_id)
#
# Foreign Keys
#
#  fk_rails_...  (match_player_id => match_players.id)
#
class PlayerStat < ApplicationRecord
  belongs_to :match_player
end
