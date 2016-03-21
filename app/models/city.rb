class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods


  def city_openings(start, fin)
    self.listings.select{|l| l.available(start, fin)}
  end

  def self.highest_ratio_res_to_listings
    ratios=self.all.collect{|c| [c, (c.reservations.count.to_f/c.listings.count.to_f*100).to_i]}
    ratios.sort_by{|c, r| r}.last[0]
    # City.find_by(name: city_name)
# binding.pry
  end

  def self.most_res
    self.all.sort{|c| c.reservations}

  end

  def self.most_res
    #returs city object



  end

  def reservations
    self.listings.collect{|l| l.reservations}.flatten
  end

end


# c.listings.count.to_f/c.reservations.count.to_f
