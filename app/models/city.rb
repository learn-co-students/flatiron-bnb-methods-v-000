class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, through: :neighborhoods
  has_many :reservations, through: :listings

  include Available::InstanceMethods
  extend Available::ClassMethods

  # def city_openings(start_date, end_date)
  #   self.listings.each do |listing|
  #     listing.reservations.where(":checkin >= ? AND :checkout <= ? AND :status != ?", start_date, end_date, "accepted")
  #   end
  # end

  def city_openings(start_date, end_date)
    openings(start_date, end_date)
  end


  # def self.highest_ratio_res_to_listings
  #   all.max do |a, b|
  #     (a.reservations.count.to_f / a.listings.count.to_f) <=> (b.reservations.count.to_f / b.listings.count.to_f)
  #   end
  # end

  def self.most_res
    all.max do |a, b|
      a.reservations.count <=> b.reservations.count
    end
  end

end

