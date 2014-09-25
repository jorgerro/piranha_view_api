class Api::TimeslotsController < ApplicationController
  
  def create
    
    # @timeslot = Timeslot.new(start_time: timeslot_params[start_time], duration: timeslot_params[duration])
    @timeslot = Timeslot.new(timeslot_params)

    if @timeslot.save
      render "api/timeslot"
    else
      # head :bad_request
      puts "SOMETHING WENT WRONG IN TIMESLOT CREATE"
      render json: @timslot.errors, status: :unprocessable_entity
    end
    
  end
  
  def index
    # Everything is in GMT
    
    request_date = Date.parse(params[:date] || DateTime.now.strftime("%F"))
    
    day_start = request_date.strftime("%s")
    day_end = (request_date + 1).strftime("%s")
    
    @timeslots = Timeslot.where("start_time >= :day_start AND start_time <= :day_end", {
      day_start: day_start.to_i,
      day_end: day_end.to_i
    })
    # @timeslots = Timeslot.all
    
    p request_date
    p @timeslots
    
    render "api/timeslots"
  end
  
  
  private
  
    def timeslot_params
      params.require(:timeslot).permit(:start_time, :duration, :date)
    end
  
end
