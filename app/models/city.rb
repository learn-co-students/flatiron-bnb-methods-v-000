class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(date1, date2)
    #self.listings.where("date(created_at) >= #{date1} AND date(created_at) <= #{date2}")

    self.listings.select do |listing|
      listing if listing.created_at.to_date >= date1.to_date &&
       listing.created_at.to_date <= date2.to_date
    end
  end

  def self.most_res
  # city = Struct.new(:city, :reservations)

  #   self.all.each do |city|
  #     city.listings.each do |listing|
  #       cities = City.new(city, listing.reservations.count)
  #       binding.pry
  #     end
  #   end
  #   puts reservations
  # end

end

