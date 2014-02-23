class Event < ActiveRecord::Base
	 has_many :market
	 
   validates_uniqueness_of		:id
   validates_presence_of			:name
   validates_presence_of			:cc,		 length: { is: 2 }
	 validates_presence_of			:open_date

   before_save { self.cc   = cc.downcase }
end
