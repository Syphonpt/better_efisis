class ChangeInMarkets < ActiveRecord::Migration
	 def change
			rename_column :markets, :open_date, :total_matched
			change_column :markets, :total_matched, :float
	 end
end
