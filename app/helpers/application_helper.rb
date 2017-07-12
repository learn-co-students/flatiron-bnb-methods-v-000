module ApplicationHelper
	def find_openings(date1, date2)
  	date1 = Date.parse(date1.split("-").join(""))
  	date2 = Date.parse(date2.split("-").join(""))
  	listings = []  	
  	self.class.find(self.id).listings.each do |listing|
  		addme = true
  		listing.reservations.each do |reservation|
  			if date1 < reservation.checkout && date2 > reservation.checkin
  				addme = false
  			end
  		end
  		listings << listing unless addme == false
  	end
  	listings
	end
end
