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
  has_many :created_rooms, class_name: "Room", foreign_key: "created_by_id", inverse_of: :created_by, dependent: :nullify
  has_many :notifications, as: :recipient, dependent: :destroy
  has_secure_password validations: false

  has_one_attached :avatar, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :elo, numericality: { greater_than_or_equal_to: 0 }
  validates :password, format: { with: /\A[a-zA-Z0-9]+\z/, message: "solo letras y números", allow_blank: true }
end
