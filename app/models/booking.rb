class Booking < ActiveRecord::Base
  
  validates :timeslot_id, :size, presence: :true
  # validates :check_availability
  before_validation :check_availability
  

  belongs_to(
    :timeslot,
    class_name: "Timeslot",
    foreign_key: :timeslot_id,
    primary_key: :id
  )
  
  # has_many :boats, through: :timeslot, source: :boats
  
  private

  def check_availability
    return true if self.size <= self.timeslot.availability
    false
  end
  
  def validate_booking
    
    # return false right away if the booking size is larger than the largest possible availability.
    return false if !check_availability
    puts "AVAILABILITY CHECKS OUT"
    
    # after checking the availability, if there are no overlapping timeslots, you're in the clear.
    return true if self.timeslot.overlapping_timeslots.empty?
    puts "THERE ARE OVERLAPPING TIMESLOTS"
    
    # if there are overlapping timeslots but no shared boats, you're golden.
    shared_boats = self.timeslot.shared_boats
    return true if shared_boats.empty?
    puts "THERE ARE SHARED BOATS"
    
    # check to see whether the boats, excluding those that are shared, can accomodate the request.
    uniq_capacities = self.timeslot.boats.map(&:capacity)
    shared_capacities = shared_boats.map(&:capacity)
    shared_capacities.each do |shared_capacity|
      uniq_capacities.delete_at(uniq_capacities.index(shared_capacity) )
    end
    # timeslot.bookings shouldn't yet include this booking
    bookings = self.timeslot.bookings.map(&:size)
    uniq_availability = timeslot.availability(bookings, uniq_capacities)
    
    # this checks to see whether or not the request could be accomodated without the shared boats.
    return true uniq_availability >= self.size
    puts "REQUEST CANNOT BE ACCODMODATED WITHOUT SHARED BOATS"
    
    
        
    
    
    
    
    false
  end
  
  
end
