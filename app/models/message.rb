# == Schema Information
#
# Table name: messages
#
#  id              :bigint           not null, primary key
#  body            :string           default(""), not null
#  sent_at         :datetime         not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  match_player_id :bigint           not null
#
# Indexes
#
#  index_messages_on_match_player_id  (match_player_id)
#
# Foreign Keys
#
#  fk_rails_...  (match_player_id => match_players.id)
#
class Message < ApplicationRecord
  belongs_to :match_player

  validates :body, :sent_at, presence: true
end
