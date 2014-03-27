class Selection < ActiveRecord::Base
	 belongs_to	 :market
	 has_many		 :book

	 validates_uniqueness_of		:id
end
