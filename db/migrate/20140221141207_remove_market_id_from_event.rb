class RemoveMarketIdFromEvent < ActiveRecord::Migration
  def change
			remove_column :events, :market_id
  end
end
