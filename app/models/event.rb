class Event < ActiveRecord::Base
	 has_many :market
	 
   validates_uniqueness_of		:id
   validates_presence_of			:name
   validates_presence_of			:cc,		 length: { is: 2 }
	 validates_presence_of			:open_date

   before_save { 
			self.cc	= cc.downcase
	 }

	 scope :not_finished,		  -> { where.not( status: 'finished' ).order(open_date: :asc) }

	 scope :starting_now,		  -> { not_finished.where( 'open_date <= ?', 10.minutes.from_now) }
	 scope :starting_soon,	  -> { not_finished.where('open_date >= ? AND open_date < ?', 11.minutes.from_now, 2.hour.from_now) }
	 scope :starting_later,	  -> { not_finished.where( 'open_date >= ? AND open_date < ?', 2.hour.from_now, 5.hour.from_now) }
	 scope :starting_tomorow, -> { not_finished.where( 'open_date >= ? AND open_date < ?', 5.hour.from_now, 12.hour.from_now) }
	 scope :starting_someday, -> { not_finished.where( 'open_date >= ?', 12.hour.from_now) }
end
