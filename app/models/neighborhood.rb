class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(from, to)
    from = DateTime.parse(from)
    to = DateTime.parse(to)
    self.listings.select do |listing|
      listing.reservations.detect do |res|
        res.checkin.between?(from, to) || res.checkout.between?(from, to)
      end.nil?
    end
  end

  def self.highest_ratio_res_to_listings
    neighborhoods = self.all.select { |n| ! n.listings.empty?}
    neighborhoods.sort_by do |neighborhood|
      neighborhood.listings.collect do |listing|
        listing.reservations.count
      end.reduce(:+).to_r / neighborhood.listings.count.to_r
    end.last
  end

  def self.most_res
    neighborhoods = self.all.select { |n|
      ! n.listings.empty?
    }

    neighborhoods.sort_by do |n|
      n.listings.collect do |listing|
        listing.reservations.count
      end.reduce(:+)
    end.last
  end
end
