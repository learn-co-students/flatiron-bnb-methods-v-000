class Vehicle
  def wheel
    "My wheel goes round"  
  end

  def rudder
  end



end

class Car < Vehicle

  def wheel
    Wheel.new()
  end

end

class Truck < Vehicle
end

class Boat < Vehicle
  def wheel
    "There is no wheel"
  end
end

class Wheel
  def diameter
  end

  def traction
  end

end