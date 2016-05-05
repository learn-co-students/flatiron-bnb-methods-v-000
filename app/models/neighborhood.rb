class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  #unsure why this works
    def neighborhood_openings(start_date, end_date)
      listings.where(start_date, end_date)
      #also listings.merge(Listing.where((start_date, end_date))
    end

  #refactor
    def self.highest_ratio_res_to_listings
      best_ratio = {}
      all.each do |neighborhood|
        list_count = 0
        res_count = 0
        list_count += neighborhood.listings.count
        neighborhood.listings.each do |listing|
          res_count += listing.reservations.count
        end
        if res_count > 0 && list_count > 0
          ratio = res_count / list_count
          best_ratio[neighborhood] = ratio
        end
      end
      best_ratio.max_by {|key, value| value}[0]
    end

  #refactor
    def self.most_res
      most_res = {}
      all.each do |neighborhood|
        res_count = 0
        neighborhood.listings.each do |listing|
          res_count += listing.reservations.count
        end
        most_res[neighborhood] = res_count
      end
      most_res.max_by {|key, value| value}[0]
    end

end
