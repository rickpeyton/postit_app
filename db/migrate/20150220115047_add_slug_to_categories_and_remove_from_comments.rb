class AddSlugToCategoriesAndRemoveFromComments < ActiveRecord::Migration
  def change
    remove_column :comments, :slug, :string
    add_column :categories, :slug, :string
  end
end
