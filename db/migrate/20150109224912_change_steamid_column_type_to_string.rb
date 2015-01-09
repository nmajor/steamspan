class ChangeSteamidColumnTypeToString < ActiveRecord::Migration
  def up
    change_column :user_stats, :steamid, :string
  end
  def down
    change_column :user_stats, :steamid, :integer
  end
end
