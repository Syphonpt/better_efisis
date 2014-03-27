class Selection < ActiveRecord::Base
	 belongs_to	 :market
	 has_many		 :book

	 validates_presence_of	 :selection_id
	 validates_presence_of	 :market_id
	 validates_uniqueness_of :uniq

	 before_validation do
			self.uniq = Digest::MD5.hexdigest(self.market_id.to_s+self.selection_id.to_s)
	 end
end
