class ChangeEventsOpenDate < ActiveRecord::Migration
	 def change
			change_column :events, :open_date, :datetime
	 end
end
