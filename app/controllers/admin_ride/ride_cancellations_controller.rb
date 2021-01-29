class AdminRide::RideCancellationsController < ApplicationController
  def review
    @ride = Ride.find(params[:id])
  end

  def cancel
    @ride = Ride.find(params[:id])
    authorize @ride

    if ride_params[:cancellation_reason] == 'Other'
      @cancellation_reason = ride_params[:cancellation_other_reason]
    else
      @cancellation_reason = ride_params[:cancellation_reason]
    end

    if %w[pending approved scheduled].include? @ride.status
      @ride.update_attributes(status: 'canceled', cancellation_reason: @cancellation_reason)
      @ride.token&.update_attribute(:ride_id, nil)
      flash.notice = 'Ride canceled.'
      redirect_to admin_ride_index_path
    end
  end

  private
    def ride_params
      params.require(:ride).permit(:cancellation_reason, :cancellation_other_reason)
    end
end
