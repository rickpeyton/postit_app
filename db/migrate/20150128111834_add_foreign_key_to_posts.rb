class AddForeignKeyToPosts < ActiveRecord::Migration
  change_table :posts do |t|
    t.integer :user_id
  end
end
