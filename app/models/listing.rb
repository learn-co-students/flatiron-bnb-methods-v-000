class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :price, presence: true
  validates :description, presence: true
  validates :neighborhood, presence: true

  after_create :user_to_host
  after_destroy :user_to_unhost


  def average_review_rating
    avg = 0.0
    total = 0

    self.reservations.each do |reservation|

        total += reservation.review.rating

    end
    avg = total/self.reservations.count.to_f
  end

  def booked
      booked = []

    self.reservations.each do |reservation|
      booked << [reservation.checkin ..  reservation.checkout]
    end
    booked.flatten
  end

  private

    def user_to_host
      # binding.pry
      self.host.update(host: true)
    end

    def user_to_unhost
      self.host.update(host: false) if self.host.listings.count == 0

    end

end
