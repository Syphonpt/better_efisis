class CreateSelections < ActiveRecord::Migration
  def change
    create_table :selections do |t|
      t.string :name
      t.float :handicap
      t.float :lastprice
      t.float :totalmatched

      t.timestamps
    end
  end
end
