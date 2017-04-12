class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood_id, presence: true

  after_create :change_host_status
  after_destroy :change_host_status_if_no_other_listing

  def average_review_rating
    all_reservations_ids = Reservation.where("listing_id = ?",self.id).collect{|reservation| reservation.id}
    ratings = all_reservations_ids.collect{|reservation_id| Review.find_by_reservation_id(reservation_id).rating}
    ratings.sum.to_f/ratings.count.to_f
  end

  protected

    def change_host_status
      host = User.find_by_id(self.host_id)
      host.host = !host.host
      host.save
    end

    def change_host_status_if_no_other_listing
      if Listing.where("host_id = ?",self.host_id).empty? && User.find_by_id(self.host_id).host
        change_host_status
      end
    end


end
