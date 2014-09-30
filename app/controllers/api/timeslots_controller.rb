class Api::TimeslotsController < ApplicationController
  
  def create
    
    @timeslot = Timeslot.new(timeslot_params)

    if @timeslot.save
      render "api/timeslot"
    else
      render json: @timeslot.errors, status: :unprocessable_entity
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
    
    render "api/timeslots"
  end
  
  
  private
  
    def timeslot_params
      params.require(:timeslot).permit(:start_time, :duration, :date)
    end
  
end
