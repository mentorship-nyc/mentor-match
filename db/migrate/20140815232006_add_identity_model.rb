class AddIdentityModel < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.integer :user_id
      t.string  :provider,      limit: 50,  null: false
      t.string  :uid,           limit: 25,  null: false
      t.string  :token,         limit: 100, null: false
      t.string  :refresh_token, limit: 100
      t.integer :expires_at

      t.string  :nickname,      limit: 100
      t.string  :email,         limit: 255
      t.string  :first_name,    limit: 50
      t.string  :last_name,     limit: 50
      t.string  :full_name,     limit: 100
      t.string  :image,         limit: 255
      t.string  :gender
      t.string  :locale,        limit: 5
      t.string  :location,      limit: 100

      t.timestamps
    end

    add_index :identities, [:provider, :uid], unique: true
    add_index :identities, [:user_id]
  end
end
