class CreateGamesBacklogsJoinTable < ActiveRecord::Migration[7.2]
  def change
    create_join_table :games, :backlogs do |t|
      t.index :game_id
      t.index :backlog_id
    end
  end
end
