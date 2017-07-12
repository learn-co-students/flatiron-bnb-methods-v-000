module Available
  extend ActiveSupport::Concern

  def openings(checkin, checkout)
    availables = self.listings.collect{|a| a}
    self.listings.each do |listing|
      listing.reservations.each do |res|
        if (Date.parse(checkin) > res.checkin && Date.parse(checkin) < res.checkout) || (Date.parse(checkout) > res.checkin && Date.parse(checkout) < res.checkout)
          availables.delete(listing)
        end
      end
    end
    availables
  end

  def listings_count
    self.listings.count
  end

  def res_count
    count = 0
    self.listings.each do |listing|
      listing.reservations.each  {|res| count += 1}
    end
    count
  end

  def ratio
    self.res_count/self.listings_count
  end

  def listings_count
    self.listings.count
  end

  def res_count
    count = 0
    self.listings.each do |listing|
      listing.reservations.each  {|res| count += 1}
    end
    count
  end

  def ratio
    return 0 if self.listings_count == 0
    self.res_count/self.listings_count
  end

  class_methods do

    def highest_ratio_res_to_listings
      all.max {|a, b| a.ratio <=> b.ratio}
    end

    def most_res
      all.max {|a, b| a.res_count <=> b.res_count}
    end

  end



end
