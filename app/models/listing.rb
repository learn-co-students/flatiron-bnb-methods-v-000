class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
# Validations
  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood_id

  # When creating a new listing, set user as a host if user's host status is false
  after_create :set_user_as_host, if: :user_not_host?
    def user_not_host?
      user = User.find(self.host_id)

      if user.host == false
        true
      else
        false
      end
    end

    def set_user_as_host
      user = User.find(self.host_id)
      user.update(host: true)
    end

  # Before destroying listing, check if user has other listings. 
  # If this listing is their only listing, change their host status to false.
  before_destroy :strip_user_host_status, if: :no_more_user_listings?
    def no_more_user_listings?
      user = User.find(self.host_id)

      if user.listings.count == 1
        true
      else
        false
      end
    end

    def strip_user_host_status
      user = User.find(self.host_id)
      user.update(host: false)
    end


# Search methods

  # Returns the average review rating of the listing
  def average_review_rating
    self.reviews.average(:rating)
  end

end
