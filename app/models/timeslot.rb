class Timeslot < ActiveRecord::Base
  
  validates :start_time, :duration, presence: :true
  
  has_many(
    :assignments,
    class_name: "Assignment",
    primary_key: :id,
    foreign_key: :timeslot_id
    # inverse_of: :timeslot,
    # dependent_destroy: :true
  )
  
  has_many(
    :bookings,
    class_name: "Booking",
    primary_key: :id,
    foreign_key: :timeslot_id
    # inverse_of: :timeslot,
    # dependent_destroy: :true
  )
  
  has_many :boats, through: :assignments
  
  def availability(groups = self.bookings.map(&:size), capacities = self.boats.map(&:capacity))
    
    return 0 if capacities.empty?
    l_cap = capacities.length
    return capacities.max if groups.empty?

    largest_availability = 0

    i = 0
    while i < l_cap
      if capacities[i] - groups.first >= 0
        
        caps = capacities.dup
        caps[i] -= groups.first
        
        availability = availability(groups[1..-1], caps)
        largest_availability = availability if availability > largest_availability
      end
      
      i += 1
    end
      
    largest_availability
  end
  
  def customer_count
    customer_count = 0
    bookings.each do |booking|
      customer_count += booking.size
    end
    customer_count
  end
  
  def boat_ids
    self.boats.map(&:id)
  end
  
  def overlapping_timeslots
    conditions = <<-SQL
      (start_time < :end_time) AND ((start_time + (duration * 60)) > :start_time)
    SQL
    
    # duration is in minutes, start_time is in seconds
    end_time = (self.start_time + (self.duration * 60))

    overlapping_timeslots = Timeslot.where(conditions, {
      start_time: self.start_time,
      end_time: end_time
    })
    puts end_time
    if self.id.nil?
      overlapping_timeslots
    else
      overlapping_timeslots.where("id != ?", self.id)
    end
  end
  
  def shared_boats
    
    shared_boats = []
    seen = {}
    
    # populate a hash of this timeslots boat_ids
    self.boats.each { |boat| seen[boat.id] = true }
    
    # look through overlapping timeslots for any boats that they might share
    overlapping_timeslots.each do |timeslot|
      timeslot.boats.each do |boat|
        shared_boats << boat if seen[boat.id]
      end
    end
    
    shared_boats
  end
  

end
