class Neighborhood < ActiveRecord::Base
	  belongs_to :city
	  has_many :listings
	  has_many :reservations, through: :listings

	  include Accom
	  extend Accom

	  def neighborhood_openings(checkin, checkout)
		  openings(checkin, checkout)
	  end	

	  def self.highest_ratio_res_to_listings
		  most_res
	  end

	  def self.most_res	
		  area = most_reservations
		  area_res = Neighborhood.all.select {|neighborhood| area.keys[0] == neighborhood.id}
		  area_res[0]
	  end			
end
