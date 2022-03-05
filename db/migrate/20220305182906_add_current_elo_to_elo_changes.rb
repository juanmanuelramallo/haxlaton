class AddCurrentEloToEloChanges < ActiveRecord::Migration[7.0]
  def change
    add_column :elo_changes, :current_elo, :integer
  end
end
