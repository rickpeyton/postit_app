class DropTwofactorAndThenAddBack < ActiveRecord::Migration
  def change
    remove_column :users, :two_factor
    add_column :users, :two_factor, :integer
  end
end
