class Market < ActiveRecord::Base
	 has_many		 :book
	 belongs_to	 :event
end
