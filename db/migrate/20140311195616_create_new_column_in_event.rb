class CreateNewColumnInEvent < ActiveRecord::Migration
  def change
    create_table :new_column_in_events do |t|
			t.string		:status
    end
  end
end
