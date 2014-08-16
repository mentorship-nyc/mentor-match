class AddChallengeModel < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
      t.string  :name,        limit: 100, null: false
      t.string  :description, limit: 255, null: false
      t.string  :difficulty,  limit: 10,  null: false
      t.text    :problem,                 null: false
    end
  end
end
