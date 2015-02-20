class AddSlugsToCommentsAndUsers < ActiveRecord::Migration
  def change
    add_column :users, :slug, :string
    add_column :comments, :slug, :string
  end
end
