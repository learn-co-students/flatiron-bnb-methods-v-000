class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(desired_checkin, desired_checkout)
    problem_listings = []
    self.listings.each do |listing|
      listing.reservations.each do |reservation|
        if reservation_conflict?(reservation, desired_checkin, desired_checkout)
          problem_listings << listing unless problem_listings.include?(listing)
        end
      end
    end
    openings = self.listings.all - problem_listings
  end

  def reservation_conflict?(reservation, ckin, ckout)
    desired_checkin = ckin.to_date
    desired_checkout = ckout.to_date
    # return true if there is a conflict
    if reservation.checkout > desired_checkin && reservation.checkout < desired_checkout
      return true
    elsif reservation.checkin > desired_checkin && reservation.checkin < desired_checkin
      return true
    end
    return false
  end

  # Class Methods:

  ### highest_ratio_res_to_listings Version 1 ###
  # def self.highest_ratio_res_to_listings # Will always be <= 1
  #   ratios = {}
  #
  #   self.all.each do |city|
  #     res_count = 0
  #     city.listings.each do |listing|
  #       res_count += listing.reservations.size
  #     end
  #     ratios[city.name] = res_count/city.listings.size
  #   end
  #   self.find_by(name: ratios.max_by {|k,v| v}[0]) # Return the City object
  # end

  ### ALTERNATE - highest_ratio_res_to_listings Version 2 ####
  # this has less code but more #find_by calls, not sure if better or not?
  def self.highest_ratio_res_to_listings
    ratios = {}
    self.res_counts.each do |city_name, num_res|
      ratios[city_name] = num_res/self.find_by(name: city_name).listings.size
    end
    self.find_by(name: ratios.max_by {|k,v| v}[0]) # Return the City object
  end
  ### END ALTERNATE ###


  def self.most_res
    self.find_by(name: self.res_counts.max_by {|k, v| v}[0])
  end

  def self.res_counts
    res_counts_hash = {}
    self.all.each do |city|
      count = 0
      city.listings.each do |listing|
        count += listing.reservations.size
      end
      res_counts_hash[city.name] = count
    end
    res_counts_hash
  end

end
