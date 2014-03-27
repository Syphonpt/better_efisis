class CreateSelections < ActiveRecord::Migration
  def change
    create_table :selections do |t|
      t.string			 :name
      t.float				 :handicap
			t.integer			 :selection_id
			t.string			 :market_id
			t.string			 :uniq

      t.timestamps
    end
  end
end
