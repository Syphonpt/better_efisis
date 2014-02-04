class CreateOdds < ActiveRecord::Migration
  def change
    create_table :odds do |t|
      t.float :value
      t.integer :type

      t.timestamps
    end
  end
end
