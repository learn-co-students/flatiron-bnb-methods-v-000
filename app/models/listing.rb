class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :title, :description, :price, :address, :listing_type, :neighborhood_id, presence: true

  after_create :enable_host
  after_destroy :disable_host

   def average_review_rating
     review_total = 0
     rating_total = 0
     self.reservations.each do |reservation|
       review_total += 1
       rating_total += reservation.review.rating
     end

     rating_total.to_f / review_total.to_f
   end

  private
    def enable_host
      h = self.host
      h.host = true
      h.save
    end

    def disable_host
      h = self.host
      if h.listings.empty?
        h.host = false
        h.save
      end
    end
end
