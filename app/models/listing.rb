# == Schema Information
#
# Table name: listings
#
#  id              :integer          not null, primary key
#  address         :string
#  listing_type    :string
#  title           :string
#  description     :text
#  price           :decimal(8, 2)
#  neighborhood_id :integer
#  host_id         :integer
#  created_at      :datetime
#  updated_at      :datetime
#

class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood, presence: true

  # after_create :make_host
  before_destroy :check_if_remove_host

  def number_of_reservations
    reservations.count
  end

  # def make_host
  # # 	host.host = true
  # # 	host.save
  # # end

  # def check_if_remove_host
  # 	if host.listings.count < 2
	 #  	host.host = false
	 #  	host.save
	 #   end
  # end

  def self.available_from?(begin_date, end_date)
    listings_available_from(begin_date, end_date).any?
  end

  def self.listings_available_from(begin_date, end_date)
    # binding.pry For some reason does not work
    outer_joins(:reservations).where.not({reservations: {checkout: (begin_date..end_date)}}).
      where.not({reservations: {checkin: (begin_date..end_date)}})
  end

  def average_review_rating
  	reviews.average(:rating)
  end

  def available_from?(begin_date, end_date)
    !(reservations.where(checkin: begin_date..end_date) || 
      reservations.where(checkout: begin_date..end_date))
  end
end
