class AddUserFieldsToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :name,     :string,  limit: 100
    add_column :profiles, :image,    :string,  limit: 255
    add_column :profiles, :location, :string,  limit: 100
    add_column :profiles, :country,  :string,  limit: 50
    add_column :profiles, :timezone, :string,  limit: 50
    add_column :profiles, :active,   :boolean,                          default: true
  end
end
