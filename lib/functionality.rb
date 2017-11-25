module Functionality
  module ClassMethods
    def self.most_res
      list = self.all.group_by {|n| n.reservations.count}
      list = list.sort
      list.last[1][0]
    end
  end
  
  module InstanceMethods
    
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end