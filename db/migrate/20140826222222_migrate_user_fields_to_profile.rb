class MigrateUserFieldsToProfile < ActiveRecord::Migration
  def up
    execute <<-EOF
      UPDATE profiles
      SET name     = users.name,
          image    = users.image,
          location = users.location,
          country  = users.country,
          timezone = users.timezone
      FROM users
      WHERE profiles.user_id = users.id
    EOF
  end
end
