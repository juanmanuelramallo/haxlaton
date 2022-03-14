# == Schema Information
#
# Table name: scoreboard_logs
#
#  id                   :bigint           not null, primary key
#  data                 :jsonb            not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  stored_from_match_id :bigint
#
# Indexes
#
#  index_scoreboard_logs_on_stored_from_match_id  (stored_from_match_id)
#
# Foreign Keys
#
#  fk_rails_...  (stored_from_match_id => matches.id)
#
class ScoreboardLog < ApplicationRecord
  belongs_to :match, foreign_key: :stored_from_match_id

  validates :data, presence: true
end
