require_relative "concerns/available_listings"
class City < ActiveRecord::Base
    include AvailableListings::InstanceMethods
    extend AvailableListings::ClassMethods
    
    has_many :neighborhoods
    has_many :listings, :through => :neighborhoods

    def city_openings(begin_date, end_date)
        openings(begin_date, end_date)
    end

    
end

