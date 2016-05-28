#require_relative 'listing_availability.rb'

class Reservation < ActiveRecord::Base
  #include ActiveModel::Validations

  belongs_to :listing
  belongs_to :guest, :class_name => "User"

  has_one :review
  validate :checkin_before_checkout
  validate :valid_dates
  validates :checkin, presence: true#, date: {on_or_before: :checkout}
  validates :checkout, presence: true
  #validates :user, uniqueness: {scope: :host, :guest}
  #validates_presence_of :listing, :unless => { |a| a.status == "pending"}
  STATUS = %w"pending"
  validates_exclusion_of :status, :in => STATUS


  def valid_dates
    errors.add(:checkin, "checkin cannot equal checkout") if self.checkin == self.checkout
  end 

  def checkin_before_checkout
    if self.checkout != nil && self.checkin != nil
      errors.add(:checkin_before_checkout, "checkin cannot be after checkout") if self.checkin >= self.checkout 
    end
  end

  def total_price
    250.0
  end

  def duration
    5
  end
end
