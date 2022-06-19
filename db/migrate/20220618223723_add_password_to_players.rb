class AddPasswordToPlayers < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :password_digest, :string
  end
end
