require_relative "concerns/available_listings"
class Neighborhood < ActiveRecord::Base
    include AvailableListings::InstanceMethods
    extend AvailableListings::ClassMethods
    
    belongs_to :city
    has_many :listings

    def neighborhood_openings(begin_date,end_date)
        openings(begin_date,end_date)
    end

end
