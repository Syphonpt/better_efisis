class Runner < ActiveRecord::Base
	 has_and_belongs_to_many		:event

	 validates_uniqueness_of		:name

	 before_save {
			self.name		= name.downcase
	 }
end
