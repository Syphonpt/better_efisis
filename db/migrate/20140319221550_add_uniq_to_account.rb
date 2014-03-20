class AddUniqToAccount < ActiveRecord::Migration
	 def change
			add_column	:accounts,	:uniq,	 :string
			add_column	:accounts,	:ssoid,	 :string
			add_column	:accounts,	:time,	 :integer
	 end
end
