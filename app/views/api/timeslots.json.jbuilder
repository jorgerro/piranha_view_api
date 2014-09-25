json.array!(@timeslots) do |timeslot|
  json.extract! timeslot, :id, :start_time, :duration
  json.availability timeslot.availability
  json.customer_count timeslot.customer_count
  json.boats timeslot.boat_ids
end
