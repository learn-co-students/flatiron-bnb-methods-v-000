class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings


  def city_openings(start_date, end_date)

    start = Date.parse(start_date)
    end_date = Date.parse(end_date)

    openings = []
    listings.each do |listing|
      blocked = listing.reservations.any? do |r|
        start.between?(r.checkin, r.checkout) || end_date.between?(r.checkin, r.checkout)
      end
      if !blocked
        openings << listing
      end
      openings
    end
  end



  # I want to make sure that my checkin date through my checkout date does not conflict with any existing dates.
  # what is my checkin date?
  # what is my checkout date?

  # what dates are available in the listing?
  # are my checkin and checkout dates fall inbetween the available days?

  # loop through the reservations and extract the checkin and checkout dates.
  # See if My checkin date is inbetween those days
  # see if my checkout date is in between those days
  #

  def self.highest_ratio_res_to_listings

    highest_ratio = 0
    most_popular_city = ""

      City.all.each do |c|
        res  = c.reservations.count
        listing = c.listings.count

        ratio = res / listing.to_f
        if ratio > highest_ratio
          highest_ratio = ratio
          most_popular_city = c
        end
    end
        most_popular_city
  end

  def self.most_res
    most_reservations = 0
    most_res_city = ""

    City.all.each do |c|
      res = c.reservations.count

        if res > most_reservations
          most_reservations = res
          most_res_city = c
        end
      end
    most_res_city
  end



end
