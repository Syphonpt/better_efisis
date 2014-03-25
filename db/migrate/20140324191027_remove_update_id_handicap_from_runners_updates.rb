class RemoveUpdateIdHandicapFromRunnersUpdates < ActiveRecord::Migration
  def change
			remove_column	 :updates,		 :update_id
  end
end
