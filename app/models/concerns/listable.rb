module Concerns::Listable

	def trip_day_list(start_date, end_date)
		days = *1..(end_date - start_date).floor
		days.collect { |d| start_date + d }
	end
end
