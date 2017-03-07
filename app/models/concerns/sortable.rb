module Sortable
  extend ActiveSupport::Concern

  module InstanceMethods 
  end 

  module ClassMethods 
    
<<<<<<< HEAD
    def most_res
      all.max_by {|x| x.reservations.count}
    end

    def highest_ratio_res_to_listings
      all.max_by {|x| x.listings.count == 0 ? 0 : x.reservations.count/x.listings.count}
=======
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
>>>>>>> 4ad6acd6304cdd2b3caea33baa165b6a93a1dfba
    end
    
  end 

end 