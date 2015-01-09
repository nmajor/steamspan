class CreateUserStats < ActiveRecord::Migration
  def change
    create_table :user_stats do |t|
      t.integer :minutes

      t.timestamps null: false
    end
    add_index :user_stats, :minutes
  end
end
