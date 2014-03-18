class AddSelectionidToBooks < ActiveRecord::Migration
	 def change
			add_column :books, :selection_id, :integer
	 end
end
