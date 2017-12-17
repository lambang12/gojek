class Api::V1::OrdersController < ApplicationController
  skip_before_action :authorize
  before_action :set_order, only: [:show, :update, :destroy]

  def update
    unless @order.status == "Cancelled by System"
      if @order.update(order_params)
        @order.status = 'Finished'
        @order.save
        AllocationService.update_order(@order)
        #TODO update driver's order to Finished
      else
        render json: @order
        #TODO update driver's order to Cancelled by System
      end
    end
  end

  private
    def set_order
      @order = Order.find(params[:id]).decorate
    end

    def order_params
      params.require(:order).permit(:status, :driver_id)
    end
end
