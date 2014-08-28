class RemoveUserFields < ActiveRecord::Migration
  def change
    remove_column :users, :name
    remove_column :users, :image
    remove_column :users, :location
    remove_column :users, :country
    remove_column :users, :timezone
  end
end
