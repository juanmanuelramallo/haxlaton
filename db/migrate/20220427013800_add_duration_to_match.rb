class AddDurationToMatch < ActiveRecord::Migration[7.0]
  def change
    add_column :matches, :duration_secs, :integer
  end
end
