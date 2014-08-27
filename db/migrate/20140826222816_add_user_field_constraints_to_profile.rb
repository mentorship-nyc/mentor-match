class AddUserFieldConstraintsToProfile < ActiveRecord::Migration
  def up
    change_column :profiles, :name,     :string,  limit: 100, null: false
    change_column :profiles, :image,    :string,  limit: 255, null: false
    change_column :profiles, :location, :string,  limit: 100, null: false
  end

  def down
    change_column :profiles, :name,     :string,  limit: 100, null: true
    change_column :profiles, :image,    :string,  limit: 255, null: true
    change_column :profiles, :location, :string,  limit: 100, null: true

    execute <<-EOF
      UPDATE profiles
      SET name     = null,
          image    = null,
          location = null,
          country  = null,
          timezone = null
      FROM users
      WHERE profiles.user_id = users.id
    EOF
  end
end
