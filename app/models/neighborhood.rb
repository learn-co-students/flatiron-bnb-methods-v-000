class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def find_listings(range_start,range_end)
    listings_arr = []
    self.listings.each{|l| listings_arr << l.find_open_listings(range_start,range_end)}
    listings_arr
  end

  def neighborhood_openings(start_date,end_date)
    s = Time.parse(start_date)
    e = Time.parse(end_date)
    @available = []
    self.listings.each do |l|
      @available << l unless l.reservations.any? do |r|
        s.between?(r.checkin,r.checkout)
      end
    end
    @available
  end

  def self.highest_ratio_res_to_listings
    @neighborhood = {"none" => 0}
    self.all.each do |n|
      @listings = n.listings.count
      @reservations = n.reservations.count
      if @listings != 0
        ratio = @reservations / @listings
        @neighborhood = {n => ratio} if ratio > (@neighborhood.values[0] || 0)
      end
    end
    @neighborhood.keys[0]
  end

  def self.most_res
    @neighborhood_res_count_hash = {"none" => 0}
    self.all.each do |n|
      if n.reservations.count > @neighborhood_res_count_hash.values[0]
        @neighborhood_res_count_hash = {n => n.reservations.count}
      end
    end
    @neighborhood_res_count_hash.keys[0]
  end

end
