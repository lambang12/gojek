class Api::V1::OrdersController < ApplicationController
  skip_before_action :authorize
  def allocate
    order = Order.find(params[:order_id])
    if params[:status] == 'OK'
      driver = Driver.find_or_create_by(external_id: params[:driver][:id], 
        full_name: "#{params[:driver][:first_name]} #{params[:driver][:last_name]}")
      driver.update(phone: params[:driver][:phone], license_plate: params[:driver][:license_plate])
      order.update(status: 'Driver Assigned', driver: driver)
    else
      order.update(status: 'Cancelled by System')
    end

    render json: {}
    # if @order.update(order_params)
    #   redirect_to @order, notice: 'Order was successfully updated.'
    # else
    #   render :edit
    # end
  end

  private
    def order_params
      params.permit(:order_id, :driver, :status)
    end
end