module Sortable
  extend ActiveSupport::Concern

  module InstanceMethods 
  end 

  module ClassMethods 
    
    def self.most_res
      most_res = City.first
      City.all.each do |city|
        if most_res.reservations.length < city.reservations.length
           most_res = city
         end
       end
      most_res
    end

    def self.highest_ratio_res_to_listings
      store = City.first
      City.all.each do |city|
        if (store.reservations.length / store.listings.length) < (city.reservations.length / city.listings.length)
           store = city
         end
       end
      store
    end
    
  end 

end 