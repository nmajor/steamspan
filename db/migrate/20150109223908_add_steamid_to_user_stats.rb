class AddSteamidToUserStats < ActiveRecord::Migration
  def change
    add_column :user_stats, :steamid, :integer
    add_index :user_stats, :steamid
  end
end
