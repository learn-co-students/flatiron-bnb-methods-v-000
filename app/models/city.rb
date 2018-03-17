require 'pry'

class City < ActiveRecord::Base
  include Resultable

  has_many :neighborhoods
  has_many :listings, through: :neighborhoods
  has_many :reservations, through: :listings

  def city_openings(start_date, end_date)
    openings(start_date, end_date)
  end
end

