class RenameTable < ActiveRecord::Migration
  def change
    rename_table :table_votes, :votes
  end
end
