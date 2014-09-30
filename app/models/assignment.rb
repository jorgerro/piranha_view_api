class Assignment < ActiveRecord::Base
  
  validates :timeslot_id, :boat_id, presence: :true
  before_save :validate_assignment

  belongs_to(
    :timeslot,
    class_name: "Timeslot",
    foreign_key: :timeslot_id,
    primary_key: :id  )
  
  belongs_to(
    :boat,
    class_name: "Boat",
    foreign_key: :boat_id,
    primary_key: :id  )
  
  def validate_assignment

    overlapping_timeslots = self.timeslot.overlapping_timeslots

    # if there are no overlapping timeslots, the assignment is valid
    return true if overlapping_timeslots.empty?

    timeslots_with_shared_boats = []

    overlapping_timeslots.each do |timeslot|

      if timeslot.boats.include?(self.boat)
        timeslots_with_shared_boats << timeslot
      end

    end

    # if none of the overlapping timeslots need to use the boat, the assignment is valid
    return true if timeslots_with_shared_boats.empty?
    puts "IN VALIDATE ASSIGNMENT: THERE ARE TIMESLOTS WITH THIS BOAT ASSIGNED"
    
    # return false if any of the timeslots that also use this boat cannot accomodate
    # their current bookings without it, i.e. they are already using the boat
    
    timeslots_with_shared_boats.each do |timeslot|
      
      boats_arr = timeslot.boats
      idx = boats_arr.index(self.boat)
      new_boats_arr = boats_arr[0...idx] + boats_arr[idx + 1..-1]
      availability_without_boat = Timeslot.availability(timeslot.bookings.map(&:size), new_boats_arr.map(&:capacity))
      
      return false if !availability_without_boat
      
    end
    
    true
  end
  

end
