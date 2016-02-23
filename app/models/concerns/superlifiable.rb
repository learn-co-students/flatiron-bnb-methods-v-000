module Superlifiable
  module ClassMethods
    def highest_ratio_res_to_listings
      top_region = nil
      highest_ratio = 0

      all.each do |region|
        total_res = region.reservations.length
        total_listings = region.listings.length
        if total_res > 0
          ratio = total_res.to_f / total_listings
          unless ratio < highest_ratio
            highest_ratio = ratio
            top_region = region
          end
        end
      end

      top_region
    end

    def most_res
      top_region = nil
      most_res = 0
      all.each do |region|
        res = region.reservations.length
        unless res < most_res
          most_res = res
          top_region = region
        end
      end

      top_region
    end
  end
end
