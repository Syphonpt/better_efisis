class RemoveEventidFromEvents < ActiveRecord::Migration
  def change
			remove_column :events, :event_id
  end
end
