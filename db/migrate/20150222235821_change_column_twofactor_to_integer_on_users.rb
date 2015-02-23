class ChangeColumnTwofactorToIntegerOnUsers < ActiveRecord::Migration
  def change
    change_column :users, :two_factor, :integer
  end
end
