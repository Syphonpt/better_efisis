class Selection < ActiveRecord::Base
	 belongs_to	 :market
	 has_many		 :book

	 validates_presence_of	 :selection_id
	 validates_presence_of	 :market_id
	 validates_uniqueness_of :uniq
end
