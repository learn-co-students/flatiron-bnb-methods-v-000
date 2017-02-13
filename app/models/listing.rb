class Listing < ActiveRecord::Base
  validates :listing_type, :description, :address, :title, :price, :neighborhood, presence: true
  belongs_to :neighborhood
  belongs_to :host, class_name: "User"
  has_many :reservations
  has_many :reviews, through: :reservations
  has_many :guests, class_name: "User", through: :reservations

  #Whenever a listing is created, the user attached to that listing should be
  #converted into a "host". This means that the user's host field is set to true
  after_save :host_status_change
  #Whenever a listing is destroyed (new callback! Google it!) the user
  #attached to that listing should be converted back to a regular user.
  #That means setting the host field to false.
  before_destroy :host_status_false

  def average_review_rating
    self.reviews.average(:rating)
  end

  private

  def host_status_change
    host_1 = User.find(host_id)
    host_1.update_column(:host, "true")
  end

  def host_status_false
    host_1 = User.find(host_id)
    if host_1.listings.count <= 1
      host_1.update_column(:host, "false")
    end
  end
end

# create_table "listings", force: :cascade do |t|
#   t.string   "address"
#   t.string   "listing_type"
#   t.string   "title"
#   t.text     "description"
#   t.decimal  "price",           precision: 8, scale: 2
#   t.integer  "neighborhood_id"
#   t.integer  "host_id"
#   t.datetime "created_at",                              null: false
#   t.datetime "updated_at",                              null: false
# end
# create_table "reviews", force: :cascade do |t|
#   t.text     "description"
#   t.integer  "rating"
#   t.integer  "guest_id"
#   t.integer  "reservation_id"
#   t.datetime "created_at",     null: false
#   t.datetime "updated_at",     null: false
# end
