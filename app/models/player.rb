# == Schema Information
#
# Table name: players
#
#  id         :bigint           not null, primary key
#  elo        :integer          default(1500), not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Player < ApplicationRecord
  has_many :match_players
  has_many :matches, through: :match_players
  has_many :elo_changes, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :elo, numericality: { greater_than_or_equal_to: 0 }
end
