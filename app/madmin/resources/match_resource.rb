class MatchResource < Madmin::Resource
  # Attributes
  attribute :id, form: false
  attribute :recording, index: false
  attribute :mp4_recording, index: false
  attribute :clips, index: false
  attribute :created_at, form: false
  attribute :updated_at, form: false

  # Associations
  attribute :match_players
  attribute :red_match_players
  attribute :blue_match_players
  attribute :red_players
  attribute :blue_players

  # Uncomment this to customize the display name of records in the admin area.
  # def self.display_name(record)
  #   record.name
  # end

  # Uncomment this to customize the default sort column and direction.
  # def self.default_sort_column
  #   "created_at"
  # end
  #
  # def self.default_sort_direction
  #   "desc"
  # end
end
