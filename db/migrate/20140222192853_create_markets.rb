class CreateMarkets < ActiveRecord::Migration
  def change
    create_table :markets do |t|
      t.string			 :name
      t.integer			 :open_date

			t.belongs_to	 :event

      t.timestamps
    end
  end
end
