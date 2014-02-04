class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :event_id
      t.string :market_id
      t.integer :date
      t.string :cc
      t.integer :home
      t.integer :away

      t.timestamps
    end
  end
end
