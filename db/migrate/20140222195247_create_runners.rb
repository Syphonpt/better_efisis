class CreateRunners < ActiveRecord::Migration
  def change
    create_table :runners do |t|
      t.string		:name

      t.timestamps
    end
  end
end
