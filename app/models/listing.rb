class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true

  before_save :make_host
  before_destroy :remove_host

  def booked?(start_date, end_date)
    parsed_start_date = start_date.class == String ? Date.parse(start_date) : start_date
    parsed_end_date = end_date.class == String ? Date.parse(end_date) : end_date
    reservations.any? do |reservation|
      parsed_start_date < reservation.checkout && reservation.checkin < parsed_end_date
    end
  end

  def average_review_rating
    if reviews.count > 0
      reviews.collect {|review| review.rating}.sum.to_f / reviews.count
    else
      "cannot divide by 0"
    end
  end

  private
    def make_host
      self.host.update(host: true) unless self.host.host
    end

    def remove_host
      if self.host.host && self.host.listings.count <= 1
        self.host.update(host: false)
      end
    end
end