class Market < ActiveRecord::Base
	 has_many		 :book
	 belongs_to	 :event

	 scope :monitored,		 -> {where(has_worker: true)}
	 scope :not_monitored, -> {where(has_worker: false)}
end
