class CreateUpdates < ActiveRecord::Migration
  def change
    create_table :updates do |t|
      t.integer		:match_time
      t.string		:update_type
      t.integer		:runner_id
      t.integer		:event_id

      t.timestamps
    end
  end
end
