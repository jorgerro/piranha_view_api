class Booking < ActiveRecord::Base
  
  validates :timeslot_id, :size, presence: :true
  before_save :check_availability
  before_save :validate_booking
  

  belongs_to(
    :timeslot,
    class_name: "Timeslot",
    foreign_key: :timeslot_id,
    primary_key: :id  )
  
  # has_many :boats, through: :timeslot, source: :boats
  
  private

  def check_availability
    return true if self.size <= self.timeslot.availability
    false
  end
  
  def validate_booking
    
    # return false right away if the booking size is larger than the largest possible availability.
    return false unless check_availability
    puts "AVAILABILITY CHECKS OUT"
    
    
    # after checking the availability, if there are no overlapping timeslots, you're in the clear.
    overlapping_timeslots = self.timeslot.overlapping_timeslots
    return true if overlapping_timeslots.empty?
    puts "THERE ARE OVERLAPPING TIMESLOTS"
    
    
    # if there are overlapping timeslots but no shared boats, you're golden.
    shared_boats = self.timeslot.shared_boats
    return true if shared_boats.empty?
    puts "THERE ARE SHARED BOATS"
    
    
    # check to see whether the boats, excluding those that are shared, can accomodate the request.
    uniq_capacities = self.timeslot.boats.map(&:capacity)
    shared_capacities = shared_boats.map(&:capacity)
    
    shared_capacities.each do |shared_capacity|
      # delete the first instance of each shared capacitiy
      uniq_capacities.delete_at(uniq_capacities.index(shared_capacity))
    end
    
    # timeslot.bookings shouldn't yet include this booking
    bookings = self.timeslot.bookings.map(&:size)
    uniq_availability = Timeslot.availability(bookings, uniq_capacities)
    
    # this checks to see whether or not the request could be accomodated without the shared boats.
    return true if (uniq_availability && uniq_availability >= self.size)
    puts "REQUEST CANNOT BE ACCODMODATED WITHOUT SHARED BOATS"
    
    # the request requires one or more of the shared boats, 
    # the following code is meant to choose the optimal combination, i.e.
    # that which uses the fewest boats and has the least open space after the new booking:
    
    shared_subs = subsets(shared_boats)
    new_bookings = bookings + [self.size]

    selected_sub = []
    
    shared_subs.each do |sub|
      
      fewest_boats = nil
      smallest_leftover_availability = nil

      new_capacities = uniq_capacities + sub.map(&:capacity)
      current_availability = Timeslot.availability(bookings, new_capacities)

      next unless current_availability >= self.size
        
        leftover_availability = Timeslot.availability(new_bookings, new_capacities)
        
        if !fewest_boats && !smallest_leftover_availability
          fewest_boats = sub.length
          smallest_leftover_availability = leftover_availability
          selected_sub = sub
          next
        end
        
        if sub.length <= fewest_boats && leftover_availability < smallest_leftover_availability
          fewest_boats = sub.length
          smallest_leftover_availability = leftover_availability
          selected_sub = sub
        end
        
      end
      
      # we must now remove other assignments that use the selected shared boats
      selected_sub_ids = selected_sub.map(&:id)
      query_string = 'boat_id IN ( '
      selected_sub_ids.length.times { query_string = query_string + '?, ' }
      query_string = query_string[0...-2] + ' )'
      
      overlapping_timeslots.each do |timeslot|
        
        assignments = timeslot.assignments.where(query_string, *(selected_sub_ids))
        assignments.each do |record|
          record.destroy!
        end
        
      end
    
    true
  end

  def subsets(arr)

    return [[]] if arr.empty?

    val = arr[0]
    subs = subsets(arr[1..-1])
    new_subs = subs.map { |sub| sub + [val] }

    subs.concat(new_subs) 
    
  end
  
end
