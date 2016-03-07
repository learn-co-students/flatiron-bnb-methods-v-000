class Listing < ActiveRecord::Base
  #associations
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  #validations
  validates :address, :listing_type, :title, :description,:price,:neighborhood, presence: true
  #callbacks
  after_create :change_host_status
  after_destroy :change_host_status

  def average_review_rating
    collection_of_ratings = self.reviews.collect {|r| r.rating}
    (collection_of_ratings.sum)/(collection_of_ratings.count).to_f
  end

  private
  def change_host_status
    #
    theuser = User.find(self.host_id)
    if theuser.listings.empty?
        theuser.host = false
        theuser.save
      else
        theuser.host = true
        theuser.save
      end

    end
  end
