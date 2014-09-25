class Api::BookingsController < ApplicationController
  
  def create
    
    @booking = Booking.new(booking_params)

    if @booking.save
      render json: @booking
    else
      # head :bad_request
      render json: @booking.errors, status: :unprocessable_entity
    end
    
  end
  
  
  private
  
    def booking_params
      params.require(:booking).permit(:timeslot_id, :size)
    end
end
