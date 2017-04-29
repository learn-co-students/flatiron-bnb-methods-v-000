class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood,  presence: :true

  after_create :set_user_to_host
  after_destroy :if_needed_unset_host

  def average_review_rating
    reviews.average(:rating)
  end

  def available(startdate, enddate)
    booked = reservations.map {|reso| (reso.checkin..reso.checkout).to_a}.flatten
    true if !booked.include?(startdate) && !booked.include?(enddate)
  end

  private

  def set_user_to_host
    host.update(host: true)
  end

  def if_needed_unset_host
    if host.listings == []
      host.update(host: false)
    end
  end
end
