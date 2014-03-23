class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string		:name
      t.datetime	:open_date
			t.string		:cc
			t.string		:status
			t.boolean		:monitored

      t.timestamps
    end
  end
end
