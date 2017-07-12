require 'active_support/concern'

module Filterable
  extend ActiveSupport::Concern

  def openings(time_one, time_two)
    if !self.listings.empty?
      available_listings = []
      input_range = [Date.parse(time_one), Date.parse(time_two)]

      self.listings.each do |listing|
        if !listing.reservations.any? { |res| overlap(input_range, [res.checkin, res.checkout]) }
          available_listings << listing
        end
      end
    end
    available_listings
  end

  def res_count
    total_reservations = 0
    self.listings.each do |listing|
      total_reservations += listing.reservations.count
    end
    total_reservations
  end

  class_methods do

    def most_res
      self.all.sort { |a, b| a.res_count <=> b.res_count }.last
    end

    def highest_ratio_res_to_listings
      self.all.sort { |a, b| (a.listings.count.to_f+1.0)/(a.res_count.to_f+1.0) <=> (b.listings.count.to_f+1.0)/(b.res_count.to_f+1.0)}.first
    end
  end

  private

  def overlap(date_range_one, date_range_two)
    !(date_range_one[0] >= date_range_two[1] || date_range_one[1] <= date_range_two[0])
  end
end
