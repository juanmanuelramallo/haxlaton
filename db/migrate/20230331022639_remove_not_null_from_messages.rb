class RemoveNotNullFromMessages < ActiveRecord::Migration[7.0]
  def change
    change_column_null :messages, :match_player_id, true
  end
end
