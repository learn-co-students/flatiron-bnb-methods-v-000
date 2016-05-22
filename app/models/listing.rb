class Listing < ActiveRecord::Base
  # Associations
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :through => :reservations

  # Validations
  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood_id

  # Callbacks
  before_create :assign_host
  after_destroy :update_host_status

  # Get the average review rating for a listing
  def average_review_rating
    reviews.average(:rating)
  end

  # Determine is a listing is available in a given checkin date
  def valid_date?(date)
    where_sql = "? BETWEEN reservations.checkin AND reservations.checkout"
    self.reservations.where(where_sql, date).count == 0
  end

  def self.openings(start_date, end_date)
    sql = <<-SQL
      listings.id NOT IN (
        SELECT distinct(listings.id) FROM listings
        JOIN reservations ON listings.id = reservations.listing_id
        WHERE ? BETWEEN reservations.checkin  AND reservations.checkout
              OR ? BETWEEN reservations.checkin AND reservations.checkout
      )
    SQL

    self.where(sql, start_date, end_date)
  end


  private

  def assign_host
    self.host.update(host: true) unless self.host.host?
  end

  def update_host_status
    self.host.update(host: false) if self.host.listings.size < 1
  end

end
