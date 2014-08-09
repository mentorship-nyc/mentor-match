class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username,  limit: 50,  null: false
      t.string :avatar,    limit: 255, null: false
      t.string :name,      limit: 255
      t.string :email,     limit: 255
      t.string :company,   limit: 100
      t.string :location,  limit: 100
    end

    add_index :users, :location
  end
end
