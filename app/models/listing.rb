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
  validates :neighborhood_id, presence: true

  after_create :change_user_host_status
  after_destroy :change_host_status_if_all_listings_destroyed

  def average_review_rating
    reviews.average(:rating).to_f
  end

  def self.available(start_date, end_date)
    booked = Reservation.booked_listings(start_date, end_date)
    if booked.empty?
      all
    else
    available = where.not("id IN (?)", booked.map {|l| l.id})
    end
  end

  def available?(start_date, end_date)
    reservations.where(checkin: start_date..end_date).empty? && reservations.where(checkout: start_date..end_date).empty? && reservations.where("checkin < ? AND checkout > ?", start_date, end_date).empty?
  end


  def self.booked(start_date, end_date)
    reservations.where("checkin BETWEEN ? and ?", start_date, end_date)
  end

  def find_reservations
    self.reservations.pluck(:checkin, :checkout)
  end

  def check_checkin(serched_checkin, checkin, checkout)
    searched_checkin.between?(checkin, checkout)
  end


  def find_res(start_date, end_date)
     start = Date.parse(start_date)
     stop = Date.parse(end_date)
     booked = self.reservations.pluck(:checkin, :checkout)
     booked.each do |dates|
        start.between?(dates[0], dates[1])
    end
  end

  private

  def change_user_host_status
    host.host = true
    host.save
  end

  def change_host_status_if_all_listings_destroyed
    if Listing.all.none? {|l| l.host_id == host_id}
      host.host = false
      host.save
    end
  end




end
