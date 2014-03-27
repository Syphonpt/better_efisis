class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
			t.integer		:selection_id
      t.float			:price
      t.float			:size
      t.integer		:side

			t.belongs_to	 :selection

      t.timestamps
    end
  end
end
