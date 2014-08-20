class AddProfileModel < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :user_id,                  null: false
      t.string  :bio,          limit: 500, null: false
      t.string  :availability, limit: 25,  null: false
      t.string  :skills,       limit: 255, null: false
      t.string  :role,         limit: 25,  null: false
    end

    add_index :profiles, [:user_id]
  end
end
