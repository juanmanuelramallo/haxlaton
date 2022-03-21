# == Schema Information
#
# Table name: matches
#
#  id             :bigint           not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  winner_team_id :integer
#
class Match < ApplicationRecord
  has_many :match_players, dependent: :destroy
  has_many :red_match_players, -> { where(team_id: 1) }, class_name: 'MatchPlayer'
  has_many :blue_match_players, -> { where(team_id: 2) }, class_name: 'MatchPlayer'
  has_many :red_players, through: :red_match_players, source: :player
  has_many :blue_players, through: :blue_match_players, source: :player

  has_one_attached :recording, dependent: :destroy

  accepts_nested_attributes_for :match_players
end
