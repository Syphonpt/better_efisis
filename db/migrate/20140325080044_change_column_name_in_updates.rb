class ChangeColumnNameInUpdates < ActiveRecord::Migration
	 def change
			rename_column :updates, :type, :update_type
	 end
end
