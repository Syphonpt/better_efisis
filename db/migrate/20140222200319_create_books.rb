class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.float :price
      t.float :size
      t.integer :type

      t.timestamps
    end
  end
end
