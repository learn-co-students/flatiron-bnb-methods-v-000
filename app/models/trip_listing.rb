class TripListing < ActiveRecord::Base
  belongs_to :trip
  belongs_to :listing
end
