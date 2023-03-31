class AddMatchAndPlayerToMessages < ActiveRecord::Migration[7.0]
  def change
    change_table :messages do |t|
      t.references :match, foreign_key: true
      t.references :player, foreign_key: true
    end
  end
end
