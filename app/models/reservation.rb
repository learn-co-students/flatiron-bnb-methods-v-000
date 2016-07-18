class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout

  def self.available?(time)
    @date = Time.parse(time)
    @reservations = self.all
    @reservations.collect do |reservation|
      @date >= reservation.checkout && @date <= reservation.checkin
    end
  end
end
