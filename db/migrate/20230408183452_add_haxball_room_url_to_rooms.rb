class AddHaxballRoomUrlToRooms < ActiveRecord::Migration[7.0]
  def change
    add_column :rooms, :haxball_room_url, :string
  end
end
