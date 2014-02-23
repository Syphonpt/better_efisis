class CreateRunners < ActiveRecord::Migration
  def change
    create_table :runners do |t|
      t.integer :runner_id
      t.integer :selection_id
      t.string :name
      t.float :handicap

      t.timestamps
    end
  end
end
