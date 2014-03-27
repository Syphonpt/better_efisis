class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string		:username
      t.string		:password
      t.string		:service
			t.string		:uniq
			t.string		:ssoid
			t.integer		:time

			t.belongs_to :user

      t.timestamps
    end
  end
end
