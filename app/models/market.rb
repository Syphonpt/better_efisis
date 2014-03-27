class Market < ActiveRecord::Base
	 has_many		 :book
	 belongs_to	 :event

	 validates_uniqueness_of		:market_id
end
