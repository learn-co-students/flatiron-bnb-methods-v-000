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

  before_create :make_user_host
  after_destroy :remove_user_host_if_all_destroyed

  def average_review_rating
    self.reviews.average(:rating)
  end

  def available?(start_date, end_date)
    self.reservations.where(
      "? <= checkout AND ? >= checkin",
      start_date,
      end_date
    ).empty?
  end

  private

    def make_user_host
      self.host.update(host: true)
    end

    def remove_user_host_if_all_destroyed
      self.host.update(host: false) if self.host.listings.empty?
    end
end
