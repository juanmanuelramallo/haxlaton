# == Schema Information
#
# Table name: messages
#
#  id              :bigint           not null, primary key
#  body            :string           default(""), not null
#  sent_at         :datetime         not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  match_id        :bigint
#  match_player_id :bigint
#  player_id       :bigint
#
# Indexes
#
#  index_messages_on_match_id         (match_id)
#  index_messages_on_match_player_id  (match_player_id)
#  index_messages_on_player_id        (player_id)
#
# Foreign Keys
#
#  fk_rails_...  (match_id => matches.id)
#  fk_rails_...  (match_player_id => match_players.id)
#  fk_rails_...  (player_id => players.id)
#
class Message < ApplicationRecord
  # TODO: Remove match_player
  # TODO: Remove optionality
  # belongs_to :match_player, optional: true
  belongs_to :match, optional: true
  belongs_to :player, optional: true

  validates :body, :sent_at, presence: true

  def match_player
    @match_player ||= MatchPlayer.find_by(match: match, player: player)
  end
end
