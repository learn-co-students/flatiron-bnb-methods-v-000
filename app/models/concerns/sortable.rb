module Sortable
  extend ActiveSupport::Concern

  module InstanceMethods 
  end 

  module ClassMethods 
    
    def most_res
      all.max_by {|x| x.reservations.count}
    end

    def highest_ratio_res_to_listings
      all.max_by {|x| x.listings.count == 0 ? 0 : x.reservations.count/x.listings.count}
    end
    
  end 

end 