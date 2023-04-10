class RoomResource < Madmin::Resource
  # Attributes
  attribute :id, form: false
  attribute :token
  attribute :name
  attribute :max_players
  attribute :password
  attribute :public
  attribute :created_at, form: false
  attribute :updated_at, form: false
  attribute :haxball_room_url

  # Associations
  attribute :created_by

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
