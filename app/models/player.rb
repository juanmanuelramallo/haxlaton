# == Schema Information
#
# Table name: players
#
#  id              :bigint           not null, primary key
#  elo             :integer          default(1500), not null
#  name            :string           not null
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Player < ApplicationRecord
  has_many :match_players, dependent: :destroy
  has_many :elo_changes, through: :match_players
  has_many :matches, through: :match_players
  has_many :player_stats, through: :match_players
  has_secure_password

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :elo, numericality: { greater_than_or_equal_to: 0 }
end
