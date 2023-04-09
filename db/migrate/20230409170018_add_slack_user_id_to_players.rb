class AddSlackUserIdToPlayers < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :slack_user_id, :string
  end
end
