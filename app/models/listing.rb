class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  

  validates :address, :listing_type, :title, :description, :price, :neighborhood_id, presence: true

  before_create :host_status_change_to_true
  before_destroy :host_status_change_to_false


  def self.available(checkin_date, checkout_date)
    if checkin_date && checkout_date
      r = Reservation.where(:checkin => checkin_date..checkout_date).pluck(:listing_id)
      r2 = Reservation.where(:checkout => checkin_date..checkout_date).pluck(:listing_id)
      where("id not in (?)", r+r2)
      else
      []
    end
  end

  def average_review_rating
    total_review_rating_counter = 0
    review_count = self.reviews.count
      self.reviews.each do |review|
        total_review_rating_counter  += review.rating
      end
    total_review_rating_counter  / review_count.to_f
  end

  private

  def host_status_change_to_true
    @user = User.find(self.host.id)
    @user.host = true
    @user.save
  end

  def host_status_change_to_false
      @user = User.find(self.host.id)
      if @user.listings.count <= 1
        @user.host = false
        @user.save
      end
  end

end
