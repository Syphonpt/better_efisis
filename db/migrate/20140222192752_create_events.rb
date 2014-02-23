class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string		:name
      t.integer		:open_date
			t.string		:cc

      t.timestamps
    end
  end
end
