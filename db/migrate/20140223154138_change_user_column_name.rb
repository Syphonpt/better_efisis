class ChangeUserColumnName < ActiveRecord::Migration
	 def change
			rename_column :users, :type, :auth
	 end
end
