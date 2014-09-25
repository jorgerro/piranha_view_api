json.(@timeslot, :id, :start_time, :duration)
json.availability @timeslot.availability
json.customer_count @timeslot.customer_count
json.boats @timeslot.boat_ids