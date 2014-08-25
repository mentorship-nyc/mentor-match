class AddProfileIndexForAvailabilitySkillsRole < ActiveRecord::Migration
  def change
    add_index :profiles, [:availability, :skills, :role]
  end
end
