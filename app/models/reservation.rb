class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review



 

  def valid_dates
     checkin < checkout
  end



end


=begin
# @range=('2014-05-01'..'2014-05-05')

# def overlaps?(start, fin)
#   (self.checkin - Date.parse(fin)) * (Date.parse(start) - self.checkout) >= 0
# end

@endo=(Date.parse('2014-04-28')..Date.parse('2014-05-02'))
@starto=(Date.parse('2014-05-02')..Date.parse('2014-05-10'))
@allo=(Date.parse('2014-04-28')..Date.parse('2014-05-10'))
@allin=(Date.parse('2014-05-02')..Date.parse('2014-05-03'))

test_dates=('2014-05-01', '2014-05-05')
@testr=(Date.parse('2014-05-01')..Date.parse('2014-05-05'))

=end