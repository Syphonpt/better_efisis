class ChangeOpenDateInEvents < ActiveRecord::Migration
	 def change
			change_column :events, :open_date, :string
	 end
end
