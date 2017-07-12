class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  has_many :ratings, :through => :guests

  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood, presence: true

  after_create :make_host
  after_destroy :stop_host

  def available?(start_date, end_date)
    !self.reservations.any? { |reservation| (start_date.to_datetime <= reservation.checkout.to_datetime) and (end_date.to_datetime >= reservation.checkin.to_datetime) || (start_date.to_datetime <= reservation.checkout.to_datetime) and (end_date.to_datetime >= reservation.checkin.to_datetime)}
  end

  def average_review_rating
    ratings = []
    self.reviews.each do |review|
      ratings << review.rating
    end
    total = 0
    ratings.each { |rating| total += rating }
    avg_rating = total.to_f / self.reviews.count.to_f
  end

  private

    def make_host
      self.host.host = true
      self.host.save
    end

    def stop_host
      if Listing.find_by(host_id: self.host.id) == nil
        self.host.host = false
        self.host.save
      end
    end

end
