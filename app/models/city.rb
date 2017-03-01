class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  extend StatusMethods::ClassMethods
  include StatusMethods::InstanceMethods

#return all Listing objects available for the entire span that is inputted
#   def city_openings(checkin, checkout)
#     dates = []
#     (checkin..checkout).each {|day| dates << day}
#     self.reservations.select do |res|
#     end
#   end
#
# #returns the city with the highest amount of reservations per listing
#   def self.highest_ratio_res_to_listings
#     self.all.max_by do |city|
#       if city.listings.count > 0 && city.reservations.count > 0
#         city.reservations.count.to_f/city.listings.count.to_f
#       else
#         0
#       end
#     end
#   end
#
#   #returns city with the most total number of reservations
#   def self.most_res
#     self.all.max_by do |city|
#       city.reservations.count
#     end
#   end

end
