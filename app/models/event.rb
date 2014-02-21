class Event < ActiveRecord::Base
	 has_many :odds
	 has_many :runners

	 validates :id,					 uniqueness: true
	 validates :home,				 presence: true
	 validates :away,				 presence: true
	 validates :cc,					 presence: true
	 validates :date,				 presence: true
end
