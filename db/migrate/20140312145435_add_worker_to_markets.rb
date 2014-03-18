class AddWorkerToMarkets < ActiveRecord::Migration
	 def change
			add_column :markets, :has_worker, :boolean
			add_column :markets, :status,		  :string
	 end
end
