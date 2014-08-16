class AddUserModel < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string   :email,              limit: 255, null: false
      t.string   :name,               limit: 100, null: false
      t.string   :image,              limit: 255

      t.string   :location,           limit: 100
      t.string   :country,            limit: 50
      t.string   :timezone,           limit: 50

      t.string   :confirmation_token, limit: 50
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at

      t.boolean :active,                            default: true

      t.timestamps
    end

    add_index :users, [:email], unique: true
    add_index :users, [:confirmation_token], unique: true
  end
end
