class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates :address, :title, :description, :price, :listing_type, :neighborhood, presence: true
  before_save :make_host
  before_destroy :host_status


   def average_review_rating
      reviews.average(:rating)
   end

    def booked_dates
      reservations.collect do |r|
        (r.checkin..r.checkout).to_a
      end.flatten.uniq
    end

   private

   def make_host
      unless self.host.host
        self.host.update(:host => true)
      end
    end

    def host_status
      if self.host.listings.count <= 1
        self.host.update(:host => false)
      end
    end



end
