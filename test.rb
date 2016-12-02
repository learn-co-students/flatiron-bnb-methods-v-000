
checkin = nil
checkout = "string"



  def checkin_order
    checkin = nil
    checkout = ""
    # return if true
    # binding.pry
    return if [checkin, checkout].any? {|f| f.nil?}
    puts "did not return"

  end

  checkin_order