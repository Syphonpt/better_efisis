class Account < ActiveRecord::Base
	 belongs_to :user

	 validates_presence_of			:username
	 validates_presence_of			:password
	 validates_presence_of			:service
	 validates_uniqueness_of		:uniq

	 before_save do
			self.uniq = Digest::MD5.hexdigest(self.username+self.password+self.service)
	 end

	 scope :betfair_get_ssoid,  -> (user,pass) { where(uniq: Digest::MD5.hexdigest(user+pass+'betfair')) }
	 scope :betfair_by_creds,   -> (user,pass) { where(username: user, password: pass, service: 'betfair') }

	 def self.betfair_valid_ssoid(username,password)
			time = self.betfair_by_creds(username,password).first.time

			if time.nil?
				 return false

			elsif (Time.now.to_i - time) >= 1200
				 return false

			elsif (Time.now.to_i - time) < 1200
				 return true

			else
				 raise "Error"
			end

	 end
end
