class CreateMarkets < ActiveRecord::Migration
  def change
    create_table :markets do |t|
			t.string			 :market_id
      t.string			 :name
      t.float				 :total_matched
			t.string			 :status

			t.belongs_to	 :event

      t.timestamps
    end
  end
end
