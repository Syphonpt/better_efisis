class AddWorkerToMarkets < ActiveRecord::Migration
	 def change
			add_column :markets, :status,		  :string
	 end
end
