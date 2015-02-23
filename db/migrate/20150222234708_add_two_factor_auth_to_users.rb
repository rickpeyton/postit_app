class AddTwoFactorAuthToUsers < ActiveRecord::Migration
  def change
    add_column :users, :two_factor, :boolean
  end
end
