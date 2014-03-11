class CreateNewColumnInMarkets < ActiveRecord::Migration
	 def change
			add_column :markets, :market_id, :string
	 end
end
