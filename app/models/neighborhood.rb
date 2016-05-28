class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(beginning_date, end_date)
    available_listings = []
    listings.each do |listing|
      if listing.reservations.where("checkin >= ? AND checkout <= ?", beginning_date, end_date).empty?
        available_listings << listing
      end
    end
    available_listings
  end


  def self.highest_ratio_res_to_listings

    neighborhoods_with_scores = {}

    self.all.each do |nabe|
      number_of_listings = nabe.listings.count
      reservation_counts = nabe.listings.map { |listing| listing.reservations.count }
      sum_of_reservations = reservation_counts.inject(0) { |sum, count| sum + count }
      if sum_of_reservations == 0
        ratio_score = 2 # edge case
      else
        ratio_score = number_of_listings.to_f / sum_of_reservations.to_f
      end

      neighborhoods_with_scores[nabe] = ratio_score
    end

    neighborhoods_with_scores.min_by { |nabe, score| score }.first
  end

  def self.most_res
    neighborhoods_with_reservation_counts = {}

    self.all.each do |nabe|
      reservation_counts = nabe.listings.map { |listing| listing.reservations.count }
      sum_of_reservations = reservation_counts.inject(0) { |sum, count| sum + count }
      neighborhoods_with_reservation_counts[nabe] = sum_of_reservations
    end

    neighborhoods_with_reservation_counts.max_by { |nabe, reservations| reservations }.first
  end

end
