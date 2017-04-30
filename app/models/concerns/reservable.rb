require 'pry'
module Reservable
  extend ActiveSupport::Concern

	  def get_openings(start_date, end_date)
	  	listings.select { |listing|
	  		listing.is_available?(start_date, end_date)
	  	}
	  end

	  def ratio
	  	if reservations.count > 0 && listings.count > 0
	  		reservations.count.to_f / listings.count.to_f
	  	else
	  		0
	  	end
	  end

	class_methods do

	  def highest_ratio_res_to_listings
		  	all.max_by { |x| x.ratio }
	  end

	  def most_res
	  	all.max_by { |x|
	  		x.reservations.count }
	  end

	end
  	
end