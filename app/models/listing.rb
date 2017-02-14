class Listing < ActiveRecord::Base
  belongs_to :neighborhood, required: true
  belongs_to :host, :class_name => "User"

  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true

  after_save :change_user_to_host
  before_destroy :revoke_host_status

  def average_review_rating
    reviews.average(:rating)
  end

  def available?(start_date, end_date)
    parsed_start_date = start_date.class == String ? Date.parse(start_date) : start_date
    parsed_end_date = end_date.class == String ? Date.parse(end_date) : end_date
    reservations.any? do |reservation|
      parsed_start_date < reservation.checkout && reservation.checkin < parsed_end_date
    end
  end

  private

  def change_user_to_host
    unless self.host == true
      self.host.update(host: true)
    end
  end

  def revoke_host_status
    if self.host.listings.count <= 1
      self.host.update(host: false)
    end
  end
end
