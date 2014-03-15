class AddMarketidToBooks < ActiveRecord::Migration
	 def change
			add_column :books, :market_id,	 :string
	 end
end
